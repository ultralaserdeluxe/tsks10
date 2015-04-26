clc;clear;close all;

% Read signal
[y, fs, b] = wavread('signal-aleyn573.wav');
L = length(y);

% Transform
f_axis = fs/2*linspace(0, 1, L/2);
Y = fft(y);

% Check carrier frequencies 
plot(f_axis, abs(Y(1:L/2)));
title('Amplitude spectrum');
xlabel('frequency (Hz)');
ylabel('magnitude (abs)');
pause;

% Check which signal contains relevant data
bw = 20000; % Bandwidth
fc1 = 38000;
fc2 = 76000;
fc3 = 114000;
t_axis = linspace(0, 19.5, L)';

[B, A] = butter(10, [fc1 - bw/2, fc1 + bw/2]/(fs/2));
y1 = filter(B, A, y);
[B, A] = butter(10, [fc2 - bw/2, fc2 + bw/2]/(fs/2));
y2 = filter(B, A, y);
[B, A] = butter(10, [fc3 - bw/2, fc3 + bw/2]/(fs/2));
y3 = filter(B, A, y);

subplot(3,1,1);
plot(t_axis, y1);
title(['fc = ' num2str(fc1) 'Hz']);
subplot(3,1,2);
plot(t_axis, y2);
title(['fc = ' num2str(fc2) 'Hz']);
subplot(3,1,3);
plot(t_axis, y3);
title(['fc = ' num2str(fc3) 'Hz']);
pause;

% y3 (114 kHz) seems to be the right one

% Cross-correlation to find echo time delay
[corr, lags] = xcorr(y3, y3);
subplot(1,1,1);
plot(lags, corr);
xlabel('samples');
title('Cross correlation');
pause;

diff = 172200; % Difference in samples from xcorr plot
tau = diff * (1/fs); % Difference in seconds

% Echo cancellation
y_echo_fix = zeros(size(y3));
y_echo_fix(1:diff) = y3(1:diff);

for i=1:42
    y_echo = y3((i+1)*diff+1:(i+2)*diff);
    y_no_echo = y_echo_fix(i*diff+1:(i+1)*diff);
    
    y_echo_fix((i+1)*diff+1:(i+2)*diff) = y_echo - 0.9*y_no_echo;
end

y_echo_fix = y3;

% I/Q-demodulation
[B, A] = butter(10, bw/(fs/2), 'low');

y_i = filter(B, A, 2*y_echo_fix.*cos(2*pi*fc3*t_axis));
y_q = -filter(B, A, 2*y_echo_fix.*sin(2*pi*fc3*t_axis));

% Playback
i = decimate(y_i, 4);
q = decimate(y_q, 4);

soundsc(i, fs/4);
%soundsc(q, fs/4);