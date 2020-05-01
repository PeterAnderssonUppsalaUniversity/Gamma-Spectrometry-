function res = GetXCOM_attenuation(E, Material)
% This function gives the NIST XCOM mass attenuaton for material "Material" and
% energy E.
% Material can be scalar numeric element reference to the atom number of a single element.
% Material can be a chemical formula for a compound, e.g. 'H2O'. (elements
% need to use capital initial letter, followed by lower case second letter,
% such as He, Ne, Pu et .c.
% Material can be matrix with two rows, where the first row has atom number
% and the second row has atom concentration.
% E can be single energy or column/row array of energies in MeV
%
%
% Example:
% >> res = GetXCOM_attenuation(1.596, 'H2O')
% 
% Will give the attenuation of water for 1.596 MeV in cm^2/g
%
% res =
% 
%     0.0557
%
% Example 2:
% res = GetXCOM_attenuation([1.25 1.273 1.5], 92)
% 
% Will give the attenaution for the three energies of uranium
%
% res =
% 
%     0.0637    0.0629    0.0559
% 
% Notes:
% At flourencence energies, the attenuation data is not continous. To make
% the interpolation work, duplicate energy valuses are in the table, and
% the upper of each pair has been increased by epsilon = 1E-10 MeV
% 
% Due to differences in interpolation technique, there may be slight
% differences with NIST XCOM web iterface, where values other than tabular
% are inserted, due to interpolation routine. This function uses log-log
% linear interpolation.
% 
% Made by Peter Andersson, 2020-05-01. Please report bugs to
% peter.andersson@physics.uu.se



if isnumeric(Material) && length(Material) == 1
    % Numerical material input
    
    load NIST_XCOM Mat
    log_res = interp1( log(Mat{Material}(:,1)), log(Mat{Material}(:,2)), log(E));
    res=exp(log_res);
    
else
    % Chemical notation input
    if ~isnumeric(Material)
        [atomnums , nums, els, MCNP] = Chem2MCNP(Material);
        Material = [atomnums; nums];
        res = GetXCOM_attenuation(E, Material);
    else
        
        % matrix input got to be...
        if size(Material,1) ~= 2
            error('input error')
        else
            load atomic_weight atomic_weight % standar atomic weights from iupac https://www.qmul.ac.uk/sbcs/iupac/AtWt/
            
            for i = 1:size(Material,2) 
                massatt(i) = GetXCOM_attenuation(E, Material(1,i));
                wgt(i) = Material(2,i)* atomic_weight(Material(1,i));
            end
            res = sum(massatt.*wgt) / sum(wgt);
            
                
            end
        end
    end
end
    
    
    
    
    
    

