function result = DTMFdecoder(WaveFile,option)

SampleLength = 1024;

[RawWave,Fs,Nbits,Info]=wavread(WaveFile,[1001 SampleLength+1001-1]);
%draw raw wave
subplot(2,1,1)
plot(RawWave);
title('DTMF Raw Input');xlabel('Time');
ylabel('Amplitude');grid;
%do fft
Ts=1/Fs;
FFTWave=abs(fft(RawWave,length(RawWave)));
subplot(2,1,2)
plot(Fs/SampleLength.*[1:SampleLength/2],FFTWave(1:SampleLength/2));
title('FFT');xlabel('Continue Freq');
ylabel('Amplitude');grid;
%decode single 
result=DTMFdecoder_single(RawWave,Fs);
disp( ['The code is ' result]) 
