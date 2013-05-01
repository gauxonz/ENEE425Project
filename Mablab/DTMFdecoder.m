function result = DTMFdecoder(WaveFile,option)
%read file
[RawWave,Fs,Nbits,Info]=wavread(WaveFile);
%draw raw wave
subplot(2,1,1)
plot(RawWave);
title('DTMF Raw Input');xlabel('Time');
ylabel('Amplitude');grid;
%do fft and draw
Ts=1/Fs;
FFTWave=abs(fft(RawWave,length(RawWave)));
subplot(2,1,2)
plot(Fs/length(FFTWave).*[1:length(FFTWave)/2],FFTWave(1:length(FFTWave)/2));
title('FFT');xlabel('Continue Freq');
ylabel('Amplitude');grid;
%decode single 

%%temp
SampleLength = 1024;
result=DTMFdecoder_single(RawWave(1001:SampleLength+1001-1),Fs);

disp( ['The code is ' result]) 
