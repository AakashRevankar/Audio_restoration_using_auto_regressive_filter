clc
clear all
close all

T_start = tic;

% Read Audio File.
[data, Fs] = audioread('degraded_less.wav');

% Read Clean audio file
[data2, fs] = audioread('myclean.wav');

% Taking the 1st column of data
data = data(:, 1);
data2 = data2(:, 1);
% Plotting the data
  subplot(3, 1, 1); 
  plot(data); 
  title('Input waveform with clicks'), 
  xlabel('Number of samples'), ylabel('Amplitude');

% Important parameters
model_order = 2;
threshold = 0.23;
frame_dur = 0.5;  % frame duration

% Framing the input data
f_size = round(frame_dur * Fs); % frame size
n = length(data); 
n_f = floor(n / f_size);  %no. of frames
temp = 0; % temporary location to store f_size in for loop
for i = 1 : n_f
   frames(i, :) = data(temp + 1 : temp + f_size);
   temp = temp + f_size;
end


% Estimation of coefficients for each frame
for i = 1: n_f
    [coeffs(i, :)] = estimateARcoeffs(frames(i, :), model_order);
end

% Finding residuals for each frame
for i = 1: n_f
    [res(i, :)] = getResidual(frames(i, :), coeffs(i, :));
end

% Combining residual of each frame and plotting it
residual = reshape(res', 1, [])';
  subplot(3, 1, 2); 
  plot(residual); 
  title('Residue'),
  xlabel('Number of samples'), ylabel('Amplitude');

% Creating a error signal for each frame for the mentioned threshold
error = zeros(n_f, f_size);
for p = 1 : n_f
    for q = 1 :f_size
        if abs(res(p, q)) > threshold
            error(p, q) = 1;
        else 
            error(p, q) = 0;
        end
    end
end

% Combining the signals of each frame and plotting it
error_signal = reshape(error', 1, [])';
  subplot(3, 1, 3); 
  plot(error_signal); 
  title('Error above threshold'),
  xlabel('Number of samples'), ylabel('Amplitude');

% Function to get restored signal value of each frame by applying ...
% interpolation
for i = 1 : n_f
    [restored(i, :)] = interpolateAR(frames(i, :), error(i, :), ...
   coeffs(i, :), model_order);
end

% Combining restores signal of each frame and plotting it
restored_signal = reshape(restored', 1, [])';
  figure(2);
  subplot(3, 1, 1); 
  plot(data2); 
  title('Input waveform before degradation'),
  xlabel('Number of samples'), ylabel('Amplitude');

  subplot(3, 1, 2); 
  plot(data); 
  title('Input waveform with clicks'),
  xlabel('Number of samples'), ylabel('Amplitude');

  subplot(3, 1, 3); 
  plot(restored_signal); 
  title('Restored signal without clicks'),
  xlabel('Number of samples'), ylabel('Amplitude');

  audiowrite('restored_less.wav', restored_signal, Fs);


% To calculate Mean Square error
  data2 = data2(1 : length(restored_signal));
  M1 = data2;
  M2 = reshape(restored', 1, [])';
  MSE = sum((M1 - M2) .^ 2) / (length(M1))

  T_stop = toc(T_start)
