function result = DTMFdecoder_2(WaveFile,option)
[zewave Freq]=wavread(WaveFile);
zewave=zewave(:)'; 
DTMFCell=...
    {...
    'Tone1/Tone2'	'1209'	'1336'	'1477'	'1633';...
            '697'	'1' '2' '3' 'A';...
            '770'	'4' '5' '6' 'B';...
            '852'	'7' '8' '9' 'C';...
            '941'	'*' '0' '#' 'D'...
    };
Code=DTMFCell( 2:end,2:end)';
Tone1=cellfun(@(x) str2num(x), DTMFCell(1,2:end));
Tone2=cellfun(@(x) str2double(x), DTMFCell(2:end,1)');
[ToneMat1 ToneMat2] =ndgrid(Tone1,Tone2);
k=1;
figure(1);
TD=.5; % tone duration in second
subplot(4,4,1)
k=1;
MaxAmplitude=zeros(numel(Tone1)*numel(Tone2),1);
for TonePair=[ToneMat1(:)';ToneMat2(:)']
    ComplexTone=(cos(2*pi*( (0:1/Freq:TD) *TonePair(1)))+j*cos(2*pi*( (0:1/Freq:TD) *TonePair(2)))); 
%    subplot(3,4,k)
    subplot(4,4,k)
    XcorrData=xcorr(zewave,ComplexTone);
    Amplitude=(abs(hilbert(real(XcorrData)))+abs(hilbert(imag(XcorrData))));
    plot(Amplitude)
    MaxAmplitude(k)=max(Amplitude);
k=k+1;
       legend([ num2str(TonePair(1)) ',' num2str(TonePair(2))])
end 
[val Indx]=max(MaxAmplitude);
subplot(4,4,Indx)
text(.5,.5,'this is it', 'units', 'normalized')
disp( ['The code is ' Code{Indx}]) 