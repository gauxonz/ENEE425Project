function ResultCode = DTMFdecoder_single_Filter(PureWave,Fs)
DTMFCell=...
    {...
    'Tone1/Tone2'	'1209'	'1336'	'1477'	'1633';...
            '697'	'1'     '2'     '3'     'A';...
            '770'	'4'     '5'     '6'     'B';...
            '852'	'7'     '8'     '9'     'C';...
            '941'	'*'     '0'     '#'     'D'...
    };
Code=DTMFCell( 2:end,2:end)';
Tone1=cellfun(@(x) str2num(x), DTMFCell(1,2:end));
Tone2=cellfun(@(x) str2double(x), DTMFCell(2:end,1)');
[ToneMat1 ToneMat2] =ndgrid(Tone1,Tone2);
k=1;
MaxAmplitude=zeros(numel(Tone1)*numel(Tone2),1);

for TonePair=[ToneMat1(:)';ToneMat2(:)']
    if TonePair(1)~=TonePair(2)    
        zewave = PureWave;
        fa1=TonePair(1)-20;fa3=TonePair(1)+20;%
        fsal=TonePair(1)-40;fsah=TonePair(1)+40;%
        rpa=0.1;rsa=20;%
        wpa1=2*pi*fa1/Fs;
        wpa3=2*pi*fa3/Fs;
        wsal=2*pi*fsal/Fs;
        wsah=2*pi*fsah/Fs;
        wpa=[wpa1 wpa3];
        wsa=[wsal wsah];
        [na,wna]=cheb1ord(wsa/pi,wpa/pi,rpa,rsa);
        [bza1,aza1]=cheby1(na,rpa,wpa/pi);
        FiltedWave_1=filter(bza1,aza1,zewave);
        
        fb1=TonePair(2)-20;fb3=TonePair(2)+20;%
        fsbl=TonePair(2)-40;fsbh=TonePair(2)+40;%
        rpb=0.1;rsb=20;%
        wpb1=2*pi*fb1/Fs;
        wpb3=2*pi*fb3/Fs;
        wsbl=2*pi*fsbl/Fs;
        wsbh=2*pi*fsbh/Fs;
        wpb=[wpb1 wpb3];
        wsb=[wsbl wsbh];
        [nb,wnb]=cheb1ord(wsb/pi,wpb/pi,rpb,rsb);
        [bzb1,azb1]=cheby1(nb,rpb,wpb/pi);
        FiltedWave_2=filter(bzb1,azb1,zewave);

     MaxAmplitude(k)=max(abs(FiltedWave_1))+max(abs(FiltedWave_2));
    else
       MaxAmplitude(k)=0;
    end
 k=k+1;
end   
[val Indx]=max(MaxAmplitude);

ResultCode=Code{Indx};
end