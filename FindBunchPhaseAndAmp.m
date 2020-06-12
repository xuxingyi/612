% Get the right RF frequency information from BPM signal
clear all
load BunchTrain97600uAatt03.mat
load LUT1
load LUT2
load MyT
format long

% define the peak index of the first bunch
PeakIndex = 19689;                          
BaselineIndex = 16001:19000;
Filling = 1:720;

% define the basic number
HarmonicNum = 720;
% initial bucket size value, sampling rate 20GHz, 40*50ps = 2ns
BunchSize = 40;
% define which bunch will be processed
BunchIndexScan = Filling;

% copy raw data, processing pickup #1
Data = BPM1(PeakIndex - 10: end);
LUT = LUT1;
% remove DC offset
Baseline = mean(Data(BaselineIndex));
Data = Data - Baseline;
% for loop to process all defined bunch
N = length(BunchIndexScan);
t1 = clock;
LUTstart = 19001;
LUTlength = 2000;
TurnNum = floor(length(Data)/720/T) - 1;
for j = 1: N
%     t1 = clock;
    disp(string('j='))
    disp(j)
    BunchIndex = BunchIndexScan(j);
% define the data index for the first bunch and the dirst turn
DataIndexStart = (BunchIndex - 1) * BunchSize + 1;
% build LUT matrix for the bunch #BunchIndex
tmp1 = LUT(:,BunchIndex);
tmp2 = [tmp1' tmp1' tmp1']';
for i = 1:LUTlength
    LutMatrix(:,i) = tmp2(LUTstart+i+1000:500:LUTstart+i+19999+1000);
end
%clear tmp1 tmp2
% collect the bunch data using the final T value
DataIndexS = floor((0:1:TurnNum-1)*720*T) + DataIndexStart;
DataIndexE = DataIndexS + BunchSize - 1;
for i = 1:TurnNum
    BunchData(:,i) = Data(DataIndexS(i):DataIndexE(i));
    BunchPhase0(i) = (DataIndexS(i) - (i-1)*T*720 - (BunchIndex-1)*T) * 50;               % ps unit
    DataMatrix = repmat(BunchData(:,i)',LUTlength,1)';
    %tmp1 = mean(abs(LutMatrix-DataMatrix));
    tmp1 = mean(LutMatrix.*DataMatrix);
    %[amp ind] = min(tmp1);
    [amp,ind] = max(tmp1);
    BunchDataFit(:,i) = LutMatrix(:,ind);
    BunchPhaseFit(i) = ind * 0.1;                        % ps unit
    %clear tmp1 amp ind
    BunchPhase(i,j) = BunchPhase0(i) - BunchPhaseFit(i) + (T-40)*50*(BunchIndex-1) - PhaseBalance(BunchIndex);
    c = polyfit(BunchDataFit(:,i),BunchData(:,i),1);
    BunchAmp(j,i) = c(1);
end
% t2 = clock;
% etime(t2,t1)
%clear DataIndexS DataIndexE BunchTime TurnNum tmpWave NewWave NewTime tmpIndex
%clear LutMatrix BunchPhase0 BunchPhaseFit DataMatrix
end
BunchPhase1 = BunchPhase;
BunchAmp1 = BunchAmp;
t2 = clock;
% copy raw data, processing pickup #3
Data = BPM3(PeakIndex - 10: end);
LUT = LUT2;
% remove DC offset
Baseline = mean(Data(BaselineIndex));
Data = Data - Baseline;
% for loop to process all defined bunch
N = length(BunchIndexScan);
t3 = clock;
for j = 1: N
    j
    BunchIndex = BunchIndexScan(j);
% define the data index for the first bunch and the dirst turn
DataIndexStart = (BunchIndex - 1) * BunchSize + 1;
TurnNum = floor(length(Data)/720/T) - 1;
% build LUT matrix for the bunch #BunchIndex
tmp1 = LUT(:,BunchIndex);
tmp2 = [tmp1' tmp1' tmp1']';
LUTstart = 19001;
LUTlength = 2000;
for i = 1:LUTlength
    LutMatrix(:,i) = tmp2(LUTstart+i+1000:500:LUTstart+i+19999+1000);
end
%clear tmp1 tmp2
% collect the bunch data using the final T value
DataIndexS = floor((0:1:TurnNum-1)*720*T) + DataIndexStart;
DataIndexE = DataIndexS + BunchSize - 1;
for i = 1:TurnNum
    BunchData(:,i) = Data(DataIndexS(i):DataIndexE(i));
    BunchPhase0(i) = (DataIndexS(i) - (i-1)*T*720 - (BunchIndex-1)*T) * 50;               % ps unit
    DataMatrix = repmat(BunchData(:,i)',LUTlength,1)';
    %tmp1 = mean(abs(LutMatrix-DataMatrix));
    tmp1 = mean(LutMatrix.*DataMatrix);
    %[amp ind] = min(tmp1);
    [amp,ind] = max(tmp1);
    BunchDataFit(:,i) = LutMatrix(:,ind);
    BunchPhaseFit(i) = ind * 0.1;                        % ps unit
    %clear tmp1 amp ind
    BunchPhase(i,j) = BunchPhase0(i) - BunchPhaseFit(i) + (T-40)*50*(BunchIndex-1) - PhaseBalance(BunchIndex);
    c = polyfit(BunchDataFit(:,i),BunchData(:,i), 1);
    BunchAmp(j,i) = c(1);
    %j
end
%clear DataIndexS DataIndexE BunchTime TurnNum tmpWave NewWave NewTime tmpIndex
%clear LutMatrix BunchPhase0 BunchPhaseFit DataMatrix
end
BunchPhase3 = BunchPhase;
BunchAmp3 = BunchAmp;
t4 = clock;
save('timecost', 't1', 't2', 't3', 't4')
save('BunchPhaseResult','BunchPhase1','BunchPhase3','BunchAmp1','BunchAmp3')

%save('BunchPhaseResult','Filling','Charge','BunchPhase','current');


