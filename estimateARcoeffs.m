%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function created to calculate co-efficients and average of new data
function [coeffs] = estimateARcoeffs(data, model_order)

% Data of new block
  data_new = data(model_order + 1 : length(data));

% N value for new data
  N_new = length(data_new);

%Normalising new data
  n_D = (data_new - mean(data_new)) ./ std(data_new);

% Formula to calculate r
  j = model_order;
  for i = 1 : j
      r(i) = sum(n_D(model_order + 1 : N_new) .* n_D(j : N_new - i));
      j = j -1;
  end

  
% Formula to calculate R
  a = model_order + 1;
  for i = 1 : model_order
      for j = 1 : model_order
          R(i, j) = sum(n_D(a - i : N_new - i) .* n_D(a - j : N_new - j));
      end
  end

% Formula to calculate AR coefficients with R & r
  coeffs = - inv(R) * transpose(r);
  
end