classdef cycleGanImageDatastore < matlab.io.Datastore & ...
                                matlab.io.datastore.Shuffleable 
% cycleGanImageDatastore Create a Datastore to work with collections of images in 2 directory.
% IMDS = cycleGanImageDatastore(Xsize,Ysize,dirX, dirY) creates a Datastore,
% where Xsize/Ysize show the output size of images in X or Y directory
% and dirX/dirY are the path of the directory having image data to be used for training cycleGAN model.
% By calling read(IMDS), you can get unpaired images from each directory.                           

% Copyright 2019-2020 The MathWorks, Inc.    
    properties
        Xsize
        Ysize
        DirX
        DirY
        ImagesX
        ImagesY
        MiniBatchSize
    end
    
    properties (SetAccess = protected)
        
        NumObservations
    end
    
    methods
        function obj = cycleGanImageDatastore(Xsize,Ysize,dirX, dirY)
            obj.Xsize = Xsize;
            obj.Ysize = Ysize;
            obj.DirX = dirX;
            obj.DirY = dirY;
            obj.ImagesX = imageDatastore(obj.DirX);
            obj.ImagesY = imageDatastore(obj.DirY);
            obj.MiniBatchSize = 1;
            obj.ImagesX.ReadSize = 1;
            obj.ImagesY.ReadSize = 1;

            num = min(numel(obj.ImagesX.Files),numel(obj.ImagesY.Files));
            obj.ImagesX = obj.ImagesX.subset(1:num);
            obj.ImagesY = obj.ImagesY.subset(1:num);
            obj.NumObservations = numel(obj.ImagesX.Files);
        end
        
        function tf = hasdata(obj)
            tf = obj.ImagesX.hasdata() && obj.ImagesY.hasdata();
        end
        
        function data = read(obj) % �摜�̌Ăяo��:read a image
            obj.ImagesX.ReadSize = obj.MiniBatchSize;
            obj.ImagesY.ReadSize = obj.MiniBatchSize;
            ImagesX = obj.ImagesX.read();
            ImagesY = obj.ImagesY.read();
            
            % �o�͂�Cell�ł��낦��:set data type to cell
            if ~iscell(ImagesX)
                ImagesX = {ImagesX};
                ImagesY = {ImagesY};
            end
            % �摜�̑O����:do the preprocessing
            [transformedX, transformedY] = transformImagePair(obj,ImagesX, ImagesY);
            % ���K������:call function for normalization
            [X, Y] = obj.normalizeImages(transformedX, transformedY);
            % �e�[�u�������ďo��
            data = table(X, Y);
        end
        
        function reset(obj)
            obj.ImagesX.reset();
            obj.ImagesY.reset();
        end
        
        function objNew = shuffle(obj)
            objNew = obj.copy();
            numObservations = objNew.NumObservations;
            idx1 = randperm(numObservations);
            objNew.ImagesX.Files = objNew.ImagesX.Files(idx1);
            idx2 = randperm(numObservations);
            objNew.ImagesY.Files = objNew.ImagesY.Files(idx2);
        end
        
        function [xOut, yOut] = normalizeImages(obj, xIn, yIn)

            % �e�ő�l�����ɐ��K������:normalization with the max value
            xOut = cellfun(@(x) rescale(x,'InputMin',0,'InputMax',255), xIn, 'UniformOutput', false);
            yOut = cellfun(@(x) rescale(x,'InputMin',0,'InputMax',255), yIn, 'UniformOutput', false);
        end
    end
end

function [transformedX, transformedY] = transformImagePair(obj,ImagesX, ImagesY)

    arguments
        obj
        ImagesX (:,1) cell
        ImagesY (:,1) cell
    end
    finalSize = obj.Xsize(1:2); % �ŏI�o�͂��w��:define the size of output   
    initialSize = finalSize + 30; % �ŏ��Ƀ��T�C�Y����傫�����w��:initial image size before cropping
    mirror = rand(1) < 0.5; % 50%�̊m���Ŕ��]:flip or not
    % �f�[�^�g����K�p:Apply augmentation
    transformedX = cellfun(@(im) applyAugmentation(im, initialSize, finalSize, mirror), ...
                        ImagesX, ...
                        'UniformOutput', false);
    transformedY = cellfun(@(im) applyAugmentation(im, initialSize, finalSize, mirror), ...
                        ImagesY, ...
                        'UniformOutput', false);
end

function imOut = applyAugmentation(imIn, initialSize, finalSize, mirror)
    imInit = imresize(imIn, initialSize); % �摜�����T�C�Y
    win = randomCropWindow2d(initialSize,finalSize);
    imOut = imcrop(imInit,win);
    if mirror
        imOut = fliplr(imOut); % ���E���]:flip the image
    end
end

