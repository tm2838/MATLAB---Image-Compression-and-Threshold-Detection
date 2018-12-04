%% Image Compression and Threshold Detection Project
% This project demonstrates a potential application of MATLAB in image processing using 
% Singular Value Decomposition (SVD). It is a threshold study, which answers the question 
% of how many singular values are needed to represent a gray-scaled image so that it cannot 
% be differentiated from the original image by human eyes.

% MATLAB represents images as matrices of pixels. By decomposing the singular values of an 
% image and re-arranging them in a descending order, the low dimension representation of 
% the image which is given by the first few largest singular values can be identified. 
% A threshold is thus found by pinpointing the singular value beyond which the accuracy 
% of telling a compressed picture from the original one fell below 75%

% Notes
% 1. Pressing the two keys in instructions randomly may not work since the proportion of correct 
% responses would be 0.5 in that case, but we are lopking for a threshold where people have 75% accuracy

% 2. The picture, the svd function and 1024 sample trials can be found in the repository
%% Initialization
clear all
close all
clc

%% Parameter
tolerance = 1e-12; %input for the svd function
Fs = 40;
fS = 20;
stepSize = 50;

%% Load the image and Change the format
Lena = imread('Lena.png'); %load the image
Lena = rgb2gray(Lena); %transform it to gray scale
Lena = im2double(Lena);

%% Welcome and Instruction
%figure
screensize = get(0,'ScreenSize');
set(gcf,'position',screensize);
%display welcome
Welcometext = text(.5,.5,'Welcome!');
axis off
set(Welcometext,'HorizontalAlignment','center');
set(Welcometext,'color','k');
set(Welcometext,'FontSize',Fs);
set(Welcometext,'FontWeight','b');
shg
pause
delete(Welcometext)
%display instruction
message = sprintf('You will be shown two images, one orginal image and one compressed image.\n Press ''1'' if you think the original image is on the left. \n Press ''2'' otherwise.\n Now press any key to proceed.');
Instructiontext = text(.5,.5,message);
axis off
colormap(gray(256));
set(Instructiontext,'HorizontalAlignment','center');
set(Instructiontext,'color','k');
set(Instructiontext,'FontSize',fS);
set(Instructiontext,'FontWeight','b');
shg
pause
delete(Instructiontext)

%% Processing
%theoretically we need to iterate the full rank, but here I only use the 
%smaller half since the threshold is the smallest possible value    
compression = randperm(min(length(Lena(:,1)),length(Lena(1,:)))/2); 
position = [zeros(1,(min(length(Lena(:,1)),length(Lena(1,:))))/4)+1,...
    ones(1,(min(length(Lena(:,1)),length(Lena(1,:))))/4)+1];
pos_Index = randperm(min(length(Lena(:,1)),length(Lena(1,:)))/2);
response = [];
%for participant = 1:n       %can change n to any integer, representing how many participants are there
    for ii = 1:min(length(Lena(:,1)),length(Lena(1,:)))/2
        Lena_low = Lowrank_SVD(Lena,tolerance,compression(ii)); %using the SVD function
        pos_orig = position(pos_Index(ii));
        subplot(1,2,pos_orig),imshow(Lena);
        if pos_orig == 1
            pos_comp = pos_orig + 1;
        else pos_comp = pos_orig - 1;
        end
        subplot(1,2,pos_comp),imshow(Lena_low);
        response(ii,1) = pos_orig;
        pause
        UserPressedKey = get(gcf,'CurrentCharacter');
        response(ii,2) = UserPressedKey;
        if str2num(char(response(ii,2))) == response(ii,1)
            response(ii,3) = 1;
        else response(ii,3) = 0;
        end
        response(ii,4) = compression(ii);
        clf
    end
%end
Thankyoutext = text(.5,.5,'Thank you!');
axis off
set(Thankyoutext,'HorizontalAlignment','center');
set(Thankyoutext,'color','k');
set(Thankyoutext,'FontSize',Fs);
set(Thankyoutext,'FontWeight','b');
shg
pause(2)
close

%% Plot the threshold
correct = [];
total = [];
for ii = 1:stepSize:length(response) 
    if ii == 1
    count = sum(response(ii <= response(:,4) & response(:,4)<= ii+stepSize,3));
    totalcount = length(response(ii <= response(:,4) & response(:,4)<= ii+stepSize,3));
    elseif 1 < ii <= max(compression)
    count = sum(response(ii < response(:,4) & response(:,4)<= ii+stepSize,3)); %bin the correct trials in one stepsize togather
    totalcount = length(response(ii < response(:,4) & response(:,4)<= ii+stepSize,3)); %bin the total trials in one stepsize togather
    elseif ii > max(compression)
    count = sum(response(ii-max(compression) < response(:,4) & response(:,4)<= ii-max(compression)+stepSize,3)); 
    totalcount = length(response(ii-max(compression) < response(:,4) & response(:,4)<= ii-max(compression)+stepSize,3));   
    end
    correct = [correct;count];
    total = [total;totalcount];
end
%calculate the proportion
for jj = 1:length(total)
    prop(jj) = correct(jj)/total(jj);
end
%find the threshold
bins = 1:stepSize:max(compression);
prop(isnan(prop)==1) = [];
plot(bins,prop);      
threshold = [];
for ii = 1:length(prop)-1
    if prop(ii)>prop(ii+1) %we know that when the rank is lower, the copressed picture is less clear, and it's easier to differentiate, so the prop should decrease progressively 
        threshold_temp = interp1(prop(ii:ii+1), bins(ii:ii+1), 0.75);
    end
    threshold = [threshold;threshold_temp];
end
threshold(isnan(threshold)==1)=[];%eliminate the NaNs
threshold = min(unique(threshold)) %eliminate the repeated values if necessary
hold on
plot([threshold threshold], [0 .75], '--', 'Color', 'k')
plot([0 threshold], [.75 .75], '--', 'Color', 'k')
title('Proportion of Correct Response with Respect to Current Rank of The Image');
xlabel('Current Rank');
ylabel('Proportion of Correct Response');
xlim([1 max(compression)]);
ylim([0 1]);
set(gca,'Xtick',1:stepSize:max(compression));

