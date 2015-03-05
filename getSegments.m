function [segments] = getSegments(grayImage)
    %% Debug mode
    DEBUG=0;
    
    %% Disminuyendo de brillo de la imagen
%     grayImage = grayImage - 100;

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
    %Se dilata las región pertenecientes a la letra segmentada.
    dilatationFactor=5;
    se = strel('disk',dilatationFactor);
    dilatedImage = imdilate(segmentedImage,se);
    
    %debug mode
    if DEBUG == 1,
        figure; imshow(dilatedImage)
        title('Imagen en con bordes dilatados');        
    end
    
    %% Etiquetado de las regiones hallados
    [regions, numObj] = bwlabel(dilatedImage);
        
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