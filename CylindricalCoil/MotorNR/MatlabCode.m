% Full path to the CSV file
filePath = 'D:\MotorNR\Healthy\Calibration\scope_1.csv';


% Load your CSV data
data = readtable('D:\MotorNR\Healthy\InnerAxial&Calibration\scope_0.csv');

time = data.Var1;       % First column
amplitude = data.Var2;  % Second column

% Plot original signal
figure;
subplot(2, 2, 1);
plot(time, amplitude);
title('Original Time Domain Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

% Sampling information
Fs = 1 / mean(diff(time)); % Set sampling frequency directly (2 MSa/s)
L = length(amplitude); % Length of signal

% Apply a simple low-pass filter using a moving average
windowSize = 10; % Example: filter for 40 Hz
amplitude_filtered = movmean(amplitude, windowSize);



% Compute the FFT
Y = fft(amplitude, L);

% Compute the two-sided spectrum and single-sided spectrum
P2 = abs(Y / L);         % Two-sided spectrum
P1 = P2(1:L/2+1);       % Single-sided spectrum
P1(2:end-1) = 2 * P1(2:end-1); % Account for symmetry of FFT

% Compute frequency axis
f = Fs * (0:(L/2)) / L;

% Plot frequency domain signal (single-sided amplitude spectrum)
figure;
subplot(2, 2, 3);
plot(f, P1);
title('Single-Sided Amplitude Spectrum of Filtered Signal');
xlabel('Frequency (Hz)');
ylabel('|P1(f)|');
grid on;


