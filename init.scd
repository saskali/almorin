(
  // configure the sound server: here you could add hardware specific options
  // see http://doc.sccode.org/Classes/ServerOptions.html
  s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
  s.options.memSize = 8192 * 16 * 2; // increase this if you get "alloc failed" messages
  s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"

  // Focusrite 2i4 has 2 ins and 4 outs
  s.options.numOutputBusChannels = 4;
  s.options.numInputBusChannels = 2;

  // boot the server and start SuperDirt
  s.waitForBoot {
    // Every orbit should have 2 channels
    ~dirt = SuperDirt(2, s);
    // Load samples (path containing a wildcard can be passed in)
    // for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
    // s.sync; // optionally: wait for samples to be read
    ~dirt.loadSoundFiles;
    // start listening on port 57120
    // We spawn several orbits on the first 2 channels (main outputs)
    // and just some on the others - as they are just monitors
    ~dirt.start(57120, [0, 0, 0, 0, 0, 0, 0, 0, 2, 2]);
  };

s.latency = 0.5; // increase this if you get "late" messages
);

// ~dirt.stop();
