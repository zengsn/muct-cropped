%% prepareTrainDataDeep.m
% Prepare training data

%% Set model configuration
deepModel = 'FaceNet';
dirSuffix = ['.' deepModel];
h5File = ['.' lower(deepModel) '.h5'];
if strcmp(deepModel,'FaceNet') % FaceNet
    layerName='/dataset';
else
    disp(['Unknown model: ' deepModel]);
end

numOfAllSamples=size(inputLabel ,1);
clear trainLabel_0;
clear testLabel_0;
clear testLabel;

% record the number of samples belonging to each class
% in case of different samples in each class
eachClass=zeros(numOfClasses,1);
for ii=1:numOfClasses
    for jj=1:numOfAllSamples
        if(inputLabel(jj)==ii)
            eachClass(ii)=eachClass(ii)+1;
        end
    end %jj
end %ii
numOfSamples = min(eachClass);

%% load deep data
path = './FaceNet-20170512-110547/';
% - original
if strcmp(deepModel,'FaceNet')
    h5   = [dbNameD '_mtcnnpy_160' h5File];
else
    h5   = [dbName  '_' num2str(row) 'x' num2str(col) h5File];
end
dbName_o = dbName;
dbName   = [dbName dirSuffix];
h5Data = h5read([path h5], layerName);
h5disp([path h5], layerName);
% - mirror
if strcmp(deepModel,'FaceNet')
    h5v   = [dbNameD  '_mtcnnpy_160_v' h5File];
else
    h5v   = [dbName_o '_m_' num2str(row) 'x' num2str(col) h5File];
end
h5DataV = h5read([path h5v], layerName);
h5disp([path h5v], layerName);
%dim = size(h5Data,1);
dimOfH5Data = size(size(h5Data),2);
if dimOfH5Data==2
    for ii=1:numOfAllSamples
        inputDataDeep(:,ii)=h5Data(:,ii);
        inputDataDeepV(:,ii)=h5DataV(:,ii);
    end
elseif dimOfH5Data==4
    for ii=1:numOfAllSamples
        inputDataDeep(:,ii)=h5Data(:,1,1,ii);
        inputDataDeepV(:,ii)=h5DataV(:,1,1,ii);
    end
else
    disp('Unknown dim of data.');
end
clear h5Data;

% locate matrix for train and test data
dimDeep = size(inputDataDeep,1);
trainDataDeep_0 = zeros(numOfClasses*numOfTrain, dimDeep);
testDataDeep    = zeros(numOfAllSamples-numOfClasses*numOfTrain,dimDeep);

idx1st=0; % index of 1st (training) sample of each class
idx1stTest=0; % index of 1st test sample of each class
% select training samples randomly
for jClass=1:numOfClasses
    % Random permutation the last n samples of each class
    %if numOfTrain>mFirstSamples % add random
    %    randIdx=randperm(eachClass(jClass)-mFirstSamples)+mFirstSamples;
    %    trainIndices_0 = [1:mFirstSamples,randIdx(1:numOfTrain-mFirstSamples)]; % relative indies
    %    testIndices_0  = [randIdx(numOfTrain-mFirstSamples+1:eachClass(jClass)-mFirstSamples)];
    %else % do not add random
    trainIndices_0 = [1:numOfTrain]; % no random
    testIndices_0  = [numOfTrain+1:eachClass(jClass)]; % no random
    %end
    trainIndices=idx1st+trainIndices_0; % abosulte indies to all samples
    testIndices=idx1st+testIndices_0;   % abosulte indies to all samples
    
    % original data
    temp1=inputDataDeep(:,trainIndices)';
    % original training data, may be changed later
    trainDataDeep_0(((jClass-1)*numOfTrain+1):((jClass-1)*numOfTrain+numOfTrain),:)=temp1;
    trainLabel_0(((jClass-1)*numOfTrain+1):((jClass-1)*numOfTrain+numOfTrain),1)=jClass;
    % mirror data
    temp1=inputDataDeepV(:,trainIndices)';
    trainDataDeepV_0(((jClass-1)*numOfTrain+1):((jClass-1)*numOfTrain+numOfTrain),:)=temp1;
    % 
    numOfRestSamples=eachClass(jClass,1)-numOfTrain; % 
    % original test data, not changed 
    temp2=inputDataDeep(:,testIndices)';
    testDataDeep(idx1stTest+1:idx1stTest+numOfRestSamples,:)=temp2;
    testLabel(idx1stTest+1:idx1stTest+numOfRestSamples,1)=jClass;
    idx1stTest=idx1stTest+(eachClass(jClass,1)-numOfTrain);
    idx1st=idx1st+eachClass(jClass);
end % j

%--------------------------------------------------
numOfAllTrain = size(trainDataDeep_0,1); % total traning samples
%maxSizeOfDict = numOfAllTrain; % this usually the best size

% generate virtual samples
for iTran=1:numOfAllTrain
    % resulted training data
    trainDataDeep(2*iTran-1,:)=trainDataDeep_0(iTran,:);
    trainDataDeep(2*iTran,:)  =trainDataDeepV_0(iTran,:);
end
 
for iTran=1:numOfAllTrain
    trainLabel(2*iTran-1,1)=trainLabel_0(iTran);
    trainLabel(2*iTran,1)=trainLabel_0(iTran);
end

% prepare for representation
for kk=1:size(trainDataDeep_0,1)
    trainDataDeep_0(kk,:)=trainDataDeep_0(kk,:)/norm(trainDataDeep_0(kk,:));
end
for kk=1:size(trainDataDeep,1)
    trainDataDeep(kk,:)=trainDataDeep(kk,:)/norm(trainDataDeep(kk,:));
end

trainIndices = trainIndices_0;

%--------------------------------------------------------------------------

for kkk=1:size(testDataDeep,1)
    testDataDeep(kkk,:)=testDataDeep(kkk,:)/norm(testDataDeep(kkk,:));
end

dimOfDeep  = size(trainDataDeep,2);

numOfClasses; %
