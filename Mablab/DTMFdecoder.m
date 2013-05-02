function result = DTMFdecoder(WaveFile)
%read file
[RawWave,Fs]=wavread(WaveFile);

%position signal
HalfSampleLength=512;
EffPosition = WaveSpliter(RawWave);
a=size(EffPosition);

%set figure position
set(gcf,'Position',[0 20 1200 500]);
set(gca,'Position',[0 0 1 1]);
figure_FontSize=8;
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);

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
    plot(Fs/length(FFTWave).*(1:length(FFTWave)/2),FFTWave(1:length(FFTWave)/2));
    title('FFT');xlabel('Continue Freq');
    ylabel('Amplitude');grid;
end

disp( ['The code is ' result]) 
