classdef RightFeatures
    %UNTITLED10 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        MSER
        M_Points
        SURF
        S_Points
%         FAST
%         F_Points
        BRISK
        B_Points
    end
    
    methods
        function EObj = RightFeatures(RightImage)
            if nargin>0
                if size(RightImage.Original,3)>1
                    IR=rgb2gray(RightImage.Original);
                else
                    IR=RightImage.Original;
                end
                h = msgbox('Detecting features in right image...');
                M = detectMSERFeatures(IR);
                S = detectSURFFeatures(IR);
%                 F = detectFASTFeatures(IR);
                B = detectBRISKFeatures(IR);
                close(h); clear h
                h = msgbox('Extracting features from right image...');
                [EObj.MSER, EObj.M_Points] = extractFeatures(IR,M);
                [EObj.SURF, EObj.S_Points] = extractFeatures(IR,S);
%                 [EObj.FAST, EObj.F_Points] = extractFeatures(IR,F);
                [EObj.BRISK, EObj.B_Points] = extractFeatures(IR,B);
                close(h); clear h
            end
        end
    end
    
end

