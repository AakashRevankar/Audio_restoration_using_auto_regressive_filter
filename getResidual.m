%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used to find residual of the given data with AR co-efficients
function [res] = getResidual(data, coeffs)
  coeffs = [1, coeffs];
  data = data - mean(data);
  % The residual is found out by convolving data with FIR filter values
  res = filter(coeffs, 1, data);
end