function getSegmentsFromTrainingSet()
    close all
    clc
%% debug mode
    DEBUG = 0;

%% 1. Adquisición de la imagen para entremamiento
    grayImageOriginal = imread('trainingSet/trainingSetNumbers.png');
    grayImage = imadjust(grayImageOriginal);    
      
    %debug mode
    if DEBUG==1
        %mostrar imagen
        figure; imshow(grayImage); 
        title('Imagen en escala de grises - contrastada');        
    end
    
%% 2. Obtener los segmentos de la imagen
    segments = getSegments(grayImage,0);

%% 3. Guardar los segmentos
    numObj = length(segments);
    for k = 1 : numObj        
        imwrite(segments(k).image,['trainingSet/segmented/segment_' num2str(k,'%03d') '.png']); 
    end
end