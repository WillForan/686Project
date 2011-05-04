function takeFFT(x, Fs)
%input: x = signal to be transformed , FS = sampling rate
%
[YfreqDomain,frequencyRange] = twoSidedFFT(y,Fs);
twoSidedFFT = figure;

%remember to take the abs of YfreqDomain to get the magnitude!
stem(frequencyRange,abs(YfreqDomain));
xlabel('Freq (Hz)')
ylabel('Amplitude')
title('Two sided FFT')
grid
axis([-6,6,0,1.5])

end

function [X,freq]=twoSidedFFT(x,Fs)
%this is a custom function that helps in plotting the two-sided spectrum
%x is the signal that is to be transformed
%Fs is the sampling rate

N=length(x);

%this part of the code generates that frequency axis
if mod(N,2)==0
    k=-N/2:N/2-1; % N even
else
    k=-(N-1)/2:(N-1)/2; % N odd
end
T=N/Fs;
freq=k/T;  %the frequency axis

%takes the fft of the signal, and adjusts the amplitude accordingly
X=fft(x)/N; % normalize the data
X=fftshift(X); %shifts the fft data so that it is centered
end