function output=SSA(signal,fs,IS)
  
  
  W = fix(.025*fs); %Window length is 25 ms
  nfft = W;
  SP = 0.4; %Shift percentage is 40% (10ms) %Overlap-Add method works good with this value(.4)
  wnd = hamming(W); % returns an W-point symmetric Hamming window.
  NIS = fix((IS*fs-W)/(SP*W) +1); %number of initial silence segments
  Gamma = 1; %Magnitude Power (1 for magnitude spectral subtraction 2 for power spectrum subtraction)
  y = segment(signal,W,SP,wnd);
  Y = fft(y,nfft);
  YPhase = angle(Y(1:fix(end/2)+1,:)); %Noisy Speech Phase
  Y=abs(Y(1:fix(end/2)+1,:)).^Gamma;%Specrogram
  numberOfFrames = size(Y,2); %  return secod dimention of matrix size [ (m*n) -> n ]
  FreqResol=size(Y,1);
  N=mean(Y(:,1:NIS)')'; %initial Noise Power Spectrum mean
  NRM=zeros(size(N)); % Noise Residual Maximum (Initialization)
  NoiseCounter=0;
  NoiseLength=9; %This is a smoothing factor for the noise updating
  Beta=.03;
  
  
  YS=Y; %Y Magnitude Averaged
  for i=2:(numberOfFrames-1)
      YS(:,i)=(Y(:,i-1)+Y(:,i)+Y(:,i+1))/3;
  end

  for i=1:numberOfFrames
      [NoiseFlag, SpeechFlag, NoiseCounter, Dist] = vad(Y(:,i).^(1/Gamma),N.^(1/Gamma),NoiseCounter); %Magnitude Spectrum Distance VAD
      if SpeechFlag==0
          N=(NoiseLength*N+Y(:,i))/(NoiseLength+1); %Update and smooth noise
          NRM=max(NRM,YS(:,i)-N);%Update Maximum Noise Residue
          X(:,i)=Beta*Y(:,i);
      else
          D=YS(:,i)-N; % Specral Subtraction
          if i>1 && i<numberOfFrames %Residual Noise Reduction (from 2 to numberOfFrames-1)        
              for j=1:length(D)
                  if D(j)<NRM(j)
                      D(j)=min([D(j) YS(j,i-1)-N(j) YS(j,i+1)-N(j)]);
                  end
              end
          end
          X(:,i)=max(D,0);
      end
  end
  output=OverlapAdd2(X.^(1/Gamma),YPhase,W,SP*W);



function ReconstructedSignal=OverlapAdd2(XNEW,yphase,windowLen,ShiftLen);

if fix(ShiftLen)~=ShiftLen
    ShiftLen=fix(ShiftLen);
    disp('The shift length have to be an integer as it is the number of samples.')
    disp(['shift length is fixed to ' num2str(ShiftLen)])
end

[FreqRes FrameNum]=size(XNEW);

Spec=XNEW.*exp(j*yphase);

if mod(windowLen,2) %if FreqResol is odd
    Spec=[Spec;flipud(conj(Spec(2:end,:)))];
else
    Spec=[Spec;flipud(conj(Spec(2:end-1,:)))];
end
sig=zeros((FrameNum-1)*ShiftLen+windowLen,1);
weight=sig;
for i=1:FrameNum
    start=(i-1)*ShiftLen+1;
    spec=Spec(:,i);
    sig(start:start+windowLen-1)=sig(start:start+windowLen-1)+real(ifft(spec,windowLen));
end
ReconstructedSignal=sig;

function [NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad(signal,noise,NoiseCounter,NoiseMargin,Hangover)
if nargin<4
    NoiseMargin=3;
end
if nargin<5
    Hangover=8;
end
if nargin<3
    NoiseCounter=0;
end
FreqResol=length(signal);

SpectralDist= 20*(log10(signal)-log10(noise));
SpectralDist(find(SpectralDist<0))=0; % negative dists should be removed.

Dist=mean(SpectralDist);
if (Dist < NoiseMargin) 
    NoiseFlag=1; 
    NoiseCounter=NoiseCounter+1;
else
    NoiseFlag=0;
    NoiseCounter=0;
end

% Detect noise only periods and attenuate the signal     
if (NoiseCounter > Hangover) 
    SpeechFlag=0;    
else 
    SpeechFlag=1; % Detect noise only periods and attenuate the signal     

end 

function Seg=segment(signal,W,SP,Window)

Window=Window(:); %make it a column vector

L=length(signal);
SP=fix(W.*SP);
N=fix((L-W)/SP +1); %number of segments

Index=(repmat(1:W,N,1)+repmat((0:(N-1))'*SP,1,W))';
hw=repmat(Window,1,N);
Seg=signal(Index).*hw;

