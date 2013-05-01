function Result = WaveSpliter(RawWave)


Env = envelope([1:length(RawWave)],abs(RawWave),70,'top');
Avr = max(abs(RawWave))/2;
ResultRowIndex=1;ResultColIndex2=1;
IsDailing = 0;
for WaveIndex=1:length(RawWave)
    if Env(WaveIndex)>Avr
        if IsDailing==0
            Result(ResultRowIndex,1)=WaveIndex;
            IsDailing = 1;
        end
        
    else
        if IsDailing==1
            Result(ResultRowIndex,2)=WaveIndex;
            IsDailing=0;
            ResultRowIndex=ResultRowIndex+1;
        end
        
    end
end
% wave end
if IsDailing==1
   Result(ResultRowIndex,2)=length(RawWave);
end
