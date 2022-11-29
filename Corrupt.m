% This program is used to create a degraded signal
close all
clear all

% Read Audio File.
[data, Fs] = audioread('myclean.wav');

% Taking the 1st column of data
y = data(:, 1);
x = y;
temp = 1;
while(temp < length(y)) 
        var = randi([ -1 1], 1);
        y(temp) = var;
        temp = temp + 15000;
        
end

figure(1); 
subplot(2, 1, 1), plot(x), title('Clean source signal (myClean.wav)'), 
xlabel('Number of samples'), ylabel('Amplitude');
subplot(2, 1, 2), plot(y), title('Degraded source signal (degraded.wav)'),
xlabel('Number of samples'), ylabel('Amplitude');

audiowrite('degraded_less.wav', y, Fs);