%http://watermarkero.blogspot.mx/
%http://watermarkero.blogspot.mx/2015/03/reconocimiento-de-caracteres-usando.html
%Reconocimiento de caracteres usando Matlab

function [segments] = getSegments(grayImage,DEBUG)
    %% Valores por default
    if nargin<2, 
        DEBUG=0; 
    end;    
        
    %% Segmentación en regiones
    %Se segmenta la imagen en regiones, idealmente las regiones encontradas
    %son 2: el fondo y las letras mismas.
    thresh = multithresh(grayImage,1);
    
    %La imagen segmentada contiene SÓLO valores 1 y 2
    segmentedImage = imquantize(grayImage,thresh);
    
    %% corrección para binarización
    %Se corrige la imagen Segmentada para que tengan valores de 1 y 0. es
    %decir se "binariza"
    segmentedImage = -1*(segmentedImage -2);

        %debug mode
    if DEBUG == 1,
        figure; imshow(segmentedImage)
        title('Imagen en SIN bordes dilatados');        
    end
    
    %% Dilatar regiones
    dilateFactor=3;
    se = strel('disk',dilateFactor);
    dilatedImage = imdilate(segmentedImage,se);   
    
    %% Cerrar regiones
    %Se cierran regiones.
    closeFactor=4;
    se = strel('disk',closeFactor);
    closedImage = imclose(dilatedImage,se);    

    %% Erosion de regiones
    %Se se erosiona la imagen.
    erodeFactor=4;
    se = strel('disk',erodeFactor);
    erodedImage = imerode(closedImage,se);

    
    %debug mode
    if DEBUG == 1,
        figure; imshow(erodedImage)
        title('Imagen en con bordes erosionados');                
    end
    
    %% Etiquetado de las regiones hallados
    [regions, numObj] = bwlabel(erodedImage);
        
    %% Se obtiene el Bounding Box de las regiones conectadas
    bBox = regionprops(regions, 'BoundingBox');

    
    %debug mode
    if DEBUG == 1,
        figure; imshow(regions)
        title('Regiones halladas');        
        hold on
    end

    %% Se llena la estructura de regiones encontradas
    for k = 1 : numObj
        %se obtiene la región de imagen segmentada
        segments(k).image = regions( ...
            ceil(bBox(k).BoundingBox(1,2)) : floor(bBox(k).BoundingBox(1,2)) + floor(bBox(k).BoundingBox(1,4)), ...
            ceil(bBox(k).BoundingBox(1,1)) : floor(bBox(k).BoundingBox(1,1)) + floor(bBox(k).BoundingBox(1,3)));
        %se obtiene el centro
        segments(k).center = ceil(size(segments(k).image)/2);
        segments(k).bBox = bBox(k).BoundingBox;
        %se obtiene el tamaño
        segments(k).size = size(segments(k).image);
        
        %debug mode
        if DEBUG == 1,
            rectangle('Position', bBox(k).BoundingBox,'EdgeColor','y');
        end
    end

    %debug mode
    if DEBUG == 1, 
        hold off
    end

end