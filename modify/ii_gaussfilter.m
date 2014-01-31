function gaussFilter = ii_gaussfilter(sigma,size)
%II_GAUSSFILTER Summary of this function goes here
%   Detailed explanation goes here

x = linspace(-size / 2, size / 2, size);
gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
gaussFilter = gaussFilter / sum (gaussFilter); % normalize
end

