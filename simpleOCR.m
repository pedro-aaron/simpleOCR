%http://watermarkero.blogspot.mx/
%http://watermarkero.blogspot.mx/2015/03/reconocimiento-de-caracteres-usando.html
%Reconocimiento de caracteres usando Matlab

function simpleOcr()
    close all
    clc

    %% load dataset
    load('trainset1.mat');
    load('className1.mat');
    
    %% clasificación KNN
    model = fitcknn(trainset,className);
    model.NumNeighbors = 11;

    %% Predicción de instancias
    predictionGivenClass('0',model);
    predictionGivenClass('1',model);
    predictionGivenClass('2',model);
    predictionGivenClass('3',model);
    predictionGivenClass('4',model);
    predictionGivenClass('5',model);
    predictionGivenClass('6',model);
    predictionGivenClass('7',model);
    predictionGivenClass('8',model);
    predictionGivenClass('9',model);
    predictionGivenClass('C',model);
    predictionGivenClass('I',model);
    predictionGivenClass('E',model);
    
    %% predicción de imagen completa   
    % se obtienen los segmentos de la imagen
    segments = getSegmentsFromImage('testSet/text1.png',1);
    numObj = length(segments);
    
    %show image
    imageToTest = imread('testSet/text1.png');
    figure; imshow(imageToTest); hold on;
    title('Imagen Original'); 
    
    %dibujar segmentos y 
    for k = 1 : numObj      
        label = predictionGivenImage(model,segments(k).image);
        rectangle('Position', segments(k).bBox,'EdgeColor','r');
        text(segments(k).bBox(1) + segments(k).center(2),segments(k).bBox(2)+ segments(k).center(1),label,'Color','m','FontSize',14);
    end    
end

function predictionGivenClass(classExpected, model)
    %% Predicción de una Instancia
    imgTest = imread(['testSet/' num2str(classExpected) '.png']);
    label = predictionGivenImage(model,imgTest);
    disp(['expected:' num2str(classExpected) ' - predicted:' num2str(label)]);
end

function [label] = predictionGivenImage(model,imgTest)
    instance4test = getFeatures(imgTest);
    label = predict(model,instance4test);
end
