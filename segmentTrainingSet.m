%http://watermarkero.blogspot.mx/
%http://watermarkero.blogspot.mx/2015/03/reconocimiento-de-caracteres-usando.html
%Reconocimiento de caracteres usando Matlab

function segmentTrainingSet()
clc
clear all
close all

    folderName ='arialSegmented';
    %% se crea el folder en donde se guardar�n los segmentos
    if exist(['trainingSet/' folderName '/' ], 'dir')
        rmdir(['trainingSet/' folderName '/' ], 's');
    end
    mkdir (['trainingSet/' folderName '/' ]);
    %% se segmentan los n�meros
    for i = 0:9
        disp(['Segmentando training set: ' num2str(i)]);
        mkdir (['trainingSet/' folderName '/'  num2str(i)]);        
        getSegmentsFromTrainingSet(i,folderName);
    end
    %% se segmentan las letras
    for i = 'A':'Z'
        disp(['Segmentando training set: ' num2str(i)]);        
        mkdir (['trainingSet/' folderName '/'  i]);        
        getSegmentsFromTrainingSet(i,folderName);
    end
    
    %% se eliminan las imagenes  "ruido"    
    %Se obtiene la lista de clases
    dirList = dir(['trainingSet/' folderName]);    
    for ndir=1:length(dirList)
        if ~(strcmp(dirList(ndir).name, '.') || strcmp(dirList(ndir).name, '..'))
            if dirList(ndir).isdir == 1,
                disp(['--Limpiando training set: ' dirList(ndir).name]);        

                % se obtiene la lista de imagenes de cada clase
                imageList = dir(['trainingSet/' folderName '/' dirList(ndir).name '/*.png']);
                area = [];
                cont = 1;                
                % se obtiene la metrica que nos servir� para eliminar las
                % im�genes diferentes a las esperadas,�rea
                for nImage=1:length(imageList)
                    %se obtiene la imagen actual
                    currentImage = imread(['trainingSet/' folderName '/' dirList(ndir).name '/' imageList(nImage).name]);
                    %se halla area de la letra
                    area(cont,1) = sum(sum(currentImage));
                    cont = cont + 1;                    
                end
                %se establecen umbrales
                threshold_low = mean(area) - std(area);
                threshold_high = mean(area) + std(area);
                
                %se eliminan imagenes basura
                for nImage=1:length(imageList)
                    %se obtiene la imagen actual
                    currentImage = imread(['trainingSet/' folderName '/' dirList(ndir).name '/' imageList(nImage).name]);
                    %se halla area de la letra
                    area_current = sum(sum(currentImage));
                    % se elimina si est� afuera de los l�mites
                    if area_current < threshold_low
                        delete(['trainingSet/' folderName '/' dirList(ndir).name '/' imageList(nImage).name]);
                    end
                    if area_current > threshold_high
                        delete(['trainingSet/' folderName '/' dirList(ndir).name '/' imageList(nImage).name]);
                    end
                end
                
            end
        end
    end
    
    
end
