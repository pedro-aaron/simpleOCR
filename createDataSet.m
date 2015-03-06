function createDataSet()
    %%Se obtiene la lista de clases
    dirList = dir('trainingSet/clases');
    cont = 1; trainset = [];
    for ndir=1:length(dirList)
        if ~(strcmp(dirList(ndir).name, '.') || strcmp(dirList(ndir).name, '..'))
            if dirList(ndir).isdir == 1,
                %% se obtiene la lista de imagenes de cada lista
                imageList = dir(['trainingSet/clases/' dirList(ndir).name '/*.png']);
                for nImage=1:length(imageList)
                    currentImage = imread(['trainingSet/clases/' dirList(ndir).name '/' imageList(nImage).name]);
                    % nombre de la clase
                    className(cont,1) = dirList(ndir).name;                
                    % se obtienen los atributos de la imagen actual
                    trainset = cat(1, trainset, getFeatures(currentImage,0));
                    cont = cont + 1;                    
                end                
            end
        end
    end
    
    %% clasificación KNN
    model = fitcknn(trainset,className);
    % se establecen los vecinos
    mdl.NumNeighbors = 9;
    
    %% Predicción de instancias
    prediction('0',model);
    prediction('1',model);
    prediction('2',model);
    prediction('3',model);
    prediction('4',model);
    prediction('5',model);
    prediction('6',model);
    prediction('7',model);
    prediction('8',model);
    prediction('9',model);

end

function prediction(classExpected, model)
    %% Predicción de una Instancia
    imgTest = imread(['testSet/' num2str(classExpected) '.png']);
    disp(['testSet/' num2str(classExpected) '.png']);
    instance4test = getFeatures(imgTest);
    class = predict(model,instance4test);
    disp(['expected:' num2str(classExpected) ' - predicted:' num2str(class)]);
end