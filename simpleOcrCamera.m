%http://watermarkero.blogspot.mx/
%http://watermarkero.blogspot.mx/2015/03/reconocimiento-de-caracteres-usando.html
%Reconocimiento de caracteres usando Matlab

function simpleOCR()
%under construction---------
    close all
    clc
%% debug mode
    DEBUG = 1;

%% Configuración de la cámara, iniciar la cámara
    vid = videoinput('tisimaq_r2013', 1, 'BY8 (640x480)');
    vid.FramesPerTrigger = 1;
    vid.TriggerRepeat = Inf;
    triggerconfig(vid, 'Manual');

%% 1. Adquisición de la imagen
    start(vid);
    trigger(vid);
    capturedimage = getdata(vid);
    grayImageOriginal = rgb2gray(capturedimage);
    grayImage = imadjust(grayImageOriginal);    
      
%% Liberar cámara
    stop(vid);
    delete(vid);
    clear vid

    %debug mode
    if DEBUG==1
        %mostrar imagen capturada, RGB
        figure; imshow(capturedimage); 
        title('Imagen en original');
        
        %mostrar imagen capturada, en escala de grises
        figure; imshow(grayImageOriginal); 
        title('Imagen en escala de grises - original');
        
        grayImage_bw = im2bw(grayImage);    
        figure; imshow(grayImage_bw); 
        title('Imagen en escala de grises - BN');

        
        figure; imshow(grayImage); 
        title('Imagen en escala de grises - contrastada');

        
    end
    
%% 2. Obtener los segmentos de la imagen
    segments = getSegments(grayImage);

%% 3. Reconocer los segmentos
    numObj = length(segments);
    for k = 1 : numObj        
        %debug mode
        if DEBUG==1        
            figure; imshow(segments(k).image); 
            title(['region segmentada #' num2str(k)]);
            hold on
            plot(segments(k).center(1,2),segments(k).center(1,1), 'r*')
            hold off
        end
        
        %% La región por reconocer es segments(k).image
        % Aquí va el codigo de reconocmiento
        
    end
end