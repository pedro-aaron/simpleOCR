%http://watermarkero.blogspot.mx/
%http://watermarkero.blogspot.mx/2015/03/reconocimiento-de-caracteres-usando.html
%Reconocimiento de caracteres usando Matlab

function [segments] = getSegmentsFromImage(testImage,DEBUG)
     %% Valores por default
    if nargin<2, 
        DEBUG=0; 
    end;   

    %% 1. Carga de la imagen
    grayImageOriginal = imread(testImage);
    % si la imagen es RGB, se convierte a escala de grises
    if ndims(grayImageOriginal) == 3
        grayImageOriginal = rgb2gray(grayImageOriginal);
    end
    grayImage = imadjust(uint8(grayImageOriginal));    
      
    %debug mode
    if DEBUG==1
        %mostrar imagen
        figure; imshow(grayImage); 
        title('Imagen en escala de grises - contrastada');        
    end
    
%% 2. Obtener los segmentos de la imagen
    segments = getSegments(grayImage,DEBUG);
end