function result = DTMFdecoder(WaveFile)
%read file
[RawWave,Fs,Nbits,Info]=wavread(WaveFile);

%position signal
HalfSampleLength=512;
EffPosition = WaveSpliter(RawWave);
a=size(EffPosition);

%draw raw wave
subplot(2,a(1),1:a(1))
plot(RawWave);
title('DTMF Raw Input');xlabel('Time');
ylabel('Amplitude');grid;

for i=1:a(1)
    %decode single 
    MidSig = ceil((EffPosition(i,1)+EffPosition(i,2))/2);
    result(i) = DTMFdecoder_single(RawWave...
        (MidSig-HalfSampleLength:MidSig+HalfSampleLength),Fs);
    
    %do fft and draw
    FFTWave=abs(fft(RawWave...
        (MidSig-HalfSampleLength:MidSig+HalfSampleLength),2*HalfSampleLength));
    subplot(2,a(1),a(1)+i)
    plot(Fs/length(FFTWave).*[1:length(FFTWave)/2],FFTWave(1:length(FFTWave)/2));
    title('FFT');xlabel('Continue Freq');
    ylabel('Amplitude');grid;
end

disp( ['The code is ' result]) 
