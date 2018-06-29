% loadMUCTCropFromImages.m

%% pre-loaded data
loadMUCT;

%% data files
path = './muct/';

% landmark analysis
landmarkScopes = [path,'LandmarkScopes.mat'];
if exist(landmarkScopes,'file')==2
    load(landmarkScopes);
else
    [numOfAllSamples,numOfValues]=size(landmarks);
    numOfPoints = numOfValues / 2; % 76 points
    scopes = zeros(numOfAllSamples,4);
    for ii=1:numOfAllSamples
        landmark = landmarks(ii,:);
        left = 0;
        right= 0;
        top  = 0;
        bottom=0;
        for jj=1:numOfPoints % 76
            x1 = landmark((jj-1)*2+1);
            y1 = landmark((jj-1)*2+2);
            if left>x1
                left = x1;
            end
            if right<x1
                right = x1;
            end
            if top<y1
                top = y1;
            end
            if bottom>y1
                bottom = y1;
            end
        end
        scopes(ii,:) = [left,right,top,bottom];
    end
    % save
    save(landmarkScopes,'scopes');
end
%max(maxDistances(:,1)) % 317.3090

%% crop face images
isAlreadyCropped=1;
jpgPath = [path 'jpg/'];
cropPath= [path 'crop/'];
resizePath = [path 'resize'];
items=dir(jpgPath);
[numOfAllSamples,numOfValues]=size(landmarks);
numOfPoints = numOfValues / 2; % 76 points
p1 = zeros(1,2);
p2 = zeros(1,2);
maxRow = 0;
maxCol = 0;
if isAlreadyCropped~=1
    for ii=1:numOfAllSamples % each samples
        scope=scopes(ii,:);
        pl=scope(1); % left
        pr=scope(2); % right
        pt=scope(3); % top
        pb=scope(4); % bottom
        imageName = items(ii+2).name;
        image = imread([jpgPath imageName]);
        %subplot(1,2,1);
        %imshow(image); % full image
        [row,col,z] = size(image);
        rt = floor(0.5*row-pt);
        rb = floor(0.5*row-pb);
        rl = floor(0.5*col+pl);
        rr = floor(0.5*col+pr);
        imageCrop = image(rt:rb,rl:rr,:);
        %subplot(1,2,2);
        %imshow(imageCrop); % crop image
        [newRow,newCol,z] = size(imageCrop);
        if newRow>maxRow
            maxRow = newRow;
        end
        if newCol>maxCol
            maxCol = newCol;
        end
        % save image
        imwrite(imageCrop,[cropPath imageName]);
        %break;
    end
end

maxRow % print, 320
maxCol % print, 242

%% resize to max size
newRow = 320*0.2;
newCol = 240*0.2;
resizePath = [resizePath '_' num2str(newRow) 'x' num2str(newCol) '/'];
if ~isequal(exist(resizePath, 'dir'),7)
    mkdir(resizePath);
    for ii=1:numOfAllSamples % each samples
        imageName = items(ii+2).name;
        image = imread([cropPath imageName]);
        resizedImage = imresize(image, [newRow, newCol]);
        imwrite(resizedImage,[resizePath imageName]);
    end
end

%% convert to dataset
isRGB = 1;
clear inputData;
row = newRow;
col = newCol;
for ii=1:numOfAllSamples % each samples
    imageName = items(ii+2).name;
    image = imread([resizePath imageName]);
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);
    r1= reshape(r,row*col,1);
    g1= reshape(g,row*col,1);
    b1= reshape(b,row*col,1);
    oneSample=[r1;g1;b1];
    inputData(:,ii)=oneSample;
end

%% distance between 2 points
function distance = getDistance(p1, p2)
distance = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);
end
