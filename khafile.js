let project = new Project('KhappyBalt');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addShaders('Shaders/**');
project.addLibrary('raccoon');
project.addLibrary('delta');
resolve(project);