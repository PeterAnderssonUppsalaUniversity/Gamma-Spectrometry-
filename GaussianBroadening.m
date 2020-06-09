function res = GaussianBroadening(energy, intensity, coeffs)
% takes two input arrays of same size, energy and intensity, as well as the
% coefficients of  polynimial fit to the FWHM
%
% intensity - number of counts, or some other measure of intensity in
% spectrum bins - column vector
%
% energy - the enregy value of the energy bins (either lower, center or
% upper), unit doesn't matter, as long as compatible with coeffs - column
% vector
% 
% coeffs polynimial coefficients of a fit to the FWHM due to Gaussian broadening as a
% function of the energy, E. Same unit of FWHM as energy. Arbitrary number
% of elements
% Example: coeffs = [p1 p2 p3 ... pN] will mean that the FWHM = p1*E^N + p2 * E^(N-1) + ... + pN*E^0
%
%
% % Testing Example:
% energy = 1:200;
% energy = energy';
% 
% intensity = zeros(length(energy), 1);
% 
%  %three peaks
% intensity(100) = 100;
% intensity(150) = 100;
% intensity(160) = 100;
% 
% res = GaussianBroadening(energy,intensity, [20])
% 
% figure
% plot(energy,intensity)
% hold on 
% plot(energy,res, 'r')



% preallocating matrix
ConvMatrix = zeros(length(energy));

% estimating FWHM as function of E
FWHM = polyval(coeffs, energy);

%converting from FWHM to sigma (assuming Gaussian)
sigma = FWHM/2.355;

for i = 1:length(energy)
   
    ConvMatrix(i,:)  =  1./ sigma / sqrt(2*pi) .* exp(- (energy(i) - energy).^2 / (2*sigma(i)^2)  );
end

% convoluting broadening matrix and input intensities
res = ConvMatrix * intensity;


