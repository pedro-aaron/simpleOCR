%http://watermarkero.blogspot.mx/
%http://watermarkero.blogspot.mx/2015/03/reconocimiento-de-caracteres-usando.html
%Reconocimiento de caracteres usando Matlab

function createDataSet()
clc
close all
    %%Se obtiene la lista de clases
    folderName ='arialSegmented';    
    dirList = dir(['trainingSet/' folderName]);
    cont = 1; trainset = []; className = [];
    for ndir=1:length(dirList)
        if ~(strcmp(dirList(ndir).name, '.') || strcmp(dirList(ndir).name, '..'))
            if dirList(ndir).isdir == 1,
                %% se obtiene la lista de imagenes de cada lista
                imageList = dir(['trainingSet/' folderName '/' dirList(ndir).name '/*.png']);
                disp(['Procesando clase: ' dirList(ndir).name]);                
                for nImage=1:length(imageList)
                    currentImage = imread(['trainingSet/' folderName '/' dirList(ndir).name '/' imageList(nImage).name]);
                    % nombre de la clase
                    className(cont,1) = dirList(ndir).name;                
                    % se obtienen los atributos de la imagen actual
                    trainset = cat(1, trainset, getFeatures(currentImage,0));
                    cont = cont + 1;                    
                end                
            end
        end
    end     
    %% save dataset
    save('trainset.mat','trainset');
    save('className.mat','className');
end