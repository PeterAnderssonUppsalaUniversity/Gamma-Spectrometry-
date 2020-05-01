
function [atomnum , nums, els, MCNP] = Chem2MCNP(mat)
% Takes a chemical formula input string and returns element list of atom number
% and atom concentration, as well as MCNP format.
% 
% Example:
% 
% [Z, num, el, mcnp]  = Chem2MCNP('H2O')
% 
% Z =
% 
%      1     8
% 
% num =
% 
%      2     1
% 
% el =
% 
%   1×2 cell array
% 
%     {'H'}    {'O'}
% 
% mcnp =
% 
%     ' 1000 2 8000 1'
% 
% Made by Peter Andersson, 2020-05-01
% Please report any bugs to peter.andersson@physics.uu.se


[els,~,EndInd]=regexp(mat,['[','A':'Z','][','a':'z',']?'],'match');
[Num,NumStart]=regexp(mat,'\d+','match');
nums=ones(size(els)); % because if no number is present, it is just one
Index=ismember(EndInd+1,NumStart);
nums(Index)=cellfun(@str2num,Num);

load ElementList Z Acr Name
[LIA,atomnum]=ismember(els, Acr);
for i = 1:length(Z), cellZ{i} = num2str(Z(i)); end
MCNP = [strjoin( strsplit(strjoin(strsplit([strjoin( els, '))) '),')))']))) , strsplit(num2str(nums(1:end-1)))), num2str(nums(end))];
MCNP = regexprep(MCNP, '[A-Z]',' $&') ;
MCNP = regexprep(MCNP,')))', '000 ');
MCNP = regexprep(MCNP, Acr,cellZ);