%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This  function is used to interpolate the values
function [restored] = ...
  interpolateAR(frames, error, coeffs, model_order)

% Interpolating the signal of each frame
    v = find(error == 1);
    a = isempty(v);
    if a == 1
        restored = frames;
    else
        %Designing matrix A
        q = length(frames);
        p = q - model_order;
        A = zeros(p, q);
        x = [1 coeffs];
        for i = 1 : size(A, 1)
            A(i, i : length(x) + i - 1) = flip(x);
        end

        % To find A unknown
        Au = A( :, v);
        z = find(error == 0);

        % To find A known
        Ak = A( :, z);

        % To calculate Y known
        yk = frames(:, z);

        % Calculating the yu (Y unknown)
        yu = (- (Au)' * Au) \ ((Au)' * Ak * (yk)');

        % Restoring the value
        restored = frames;
        for i = 1 : length(v)
            restored(v(i)) = yu(i);
        end

    end
end