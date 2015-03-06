function [features] = getFeatures(img, DEBUG)
     %% Valores por default
    if nargin<2, 
        DEBUG=0; 
    end;    
    if nargin<1, 
        img = im2bw(imread('trainingSet/clases/3/segment_331.png'));
    end;    
    %casting
    img = double(img);
    %contador de caracteristicas
    cont = 1;
    center = ceil(size(img)/2);
    %% las primeras 10 caracteristicas son la distancia de los 10 puntos SURF más
    %fuertes al centro de la imagen.
    points = detectSURFFeatures(img);
    firstTen = points.selectStrongest(10);
    features = [];
    for i = 1:length(firstTen)
        posicion = firstTen(i).Location;
        features(cont) = sqrt( ...
            (center(1,1) - posicion(1,2))^2 + ...
            (center(1,2) - posicion(1,1))^2);    
        cont = cont + 1;
    end
    
    %asegurar que siempre sean 10  caracteristicas
    for i = cont:10
        features(cont) = 0;
        cont = cont + 1;
    end
        
    %% la caracteristica 11, razón nFilas/nCols
    features(cont) = center(1,1)/center(1,2);  
    cont = cont + 1;

    %% la caracteristica 12, razon de area letra - imagen
    features(cont) = sum(sum(img))/center(1,1)*center(1,2);  
    cont = cont + 1;

    %% la caracteristica 13,14 -> centroide X,centroide Y
    feature_centroid  = regionprops(img, 'centroid');
    features(cont) = feature_centroid(1).Centroid(1,1);  
    cont = cont + 1;
    features(cont) = feature_centroid(1).Centroid(1,2);  
    cont = cont + 1;
    
    %nota: usar el centro con el centroide,
    
    %% la caracteristica 15 -> numero de euler: e=#deObjetos - #deAgujerosEnLosObjetos
    feature_euler  = regionprops(img, 'EulerNumber');
    features(cont) = feature_euler(1).EulerNumber;  
    cont = cont + 1;

    %% la caracteristica 16 -> orientación de la imagen  (in degrees ranging from -90 to 90 degrees) 
    feature_orientation  = regionprops(img, 'Orientation');
    features(cont) = feature_orientation(1).Orientation;  
    cont = cont + 1;

    %% la caracteristica 17,18 -> STD X,STD Y
    features(cont) = mean(std(img));  
    cont = cont + 1;
    features(cont) = mean(std(img'));  
    cont = cont + 1;
    
    %% procesar por bloque
    nBlocks = 7;
    [nFilas, nCols] = size(img);
    sizeBlockFila = nFilas/nBlocks;
    sizeBlockCol = nCols/nBlocks;
    
    filasProcesadas = 0;    
    for f = 1:sizeBlockFila+1:nFilas
        colsProcesadas = 0;
        for c = 1:sizeBlockCol+1:nCols
            finFila = round(f + sizeBlockFila -1);
            finCol = round(c + sizeBlockCol - 1);
            if finFila>nFilas
                finFila = nFilas;
            end
            if finCol>nCols
                finCol = nCols;
            end
            imgBlock = img(round(f):finFila,round(c):finCol);
            [m,n] = size(imgBlock);
            %atributo razon caracter - bloque
            features(cont) = sum(sum(imgBlock))/(m*n);  
            cont = cont + 1;
            colsProcesadas = colsProcesadas +1;
        end        
        %asegurar que las cols procesadas sean nBloques
        for i = colsProcesadas:(nBlocks-1)
            features(cont) = 0;
            cont = cont + 1;
        end              
        filasProcesadas = filasProcesadas +1;
    end
    
    %asegurar que las cols procesadas sean nBloques
    for i = filasProcesadas:(nBlocks-1)
        features(cont) = 0;
        cont = cont + 1;
    end



    %debug mode
    if DEBUG==1
        figure;imshow(img); hold on;
        plot(points.selectStrongest(10));
        hold on
        plot(feature_centroid(1).Centroid(:,1), feature_centroid(1).Centroid(:,2), 'b*')
    end
end