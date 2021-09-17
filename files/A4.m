clear
clc
dirList = glob("voices/*.wav");
result = []
for i = 1:length(dirList)
  dirname = dirList{i,1};
  [value, freq] = getPeak(dirname);
  if( freq > 170)
    appednee = [ dirname, " women"];
    result = [result ; appednee];
  else
    appednee = [ dirname, " man"];
    result = [result ; appednee];
  end
end

