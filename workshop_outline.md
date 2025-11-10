1. What is this workshop about
1. Who are we: people who wanted to make audio plugins and managed to do this
    1. Jan
    1. Linus: he'll be answering the online questions
1. Is it your first ADC?
1. Outline
    1. There will be a break
1. Problem: A client comes to you and says: create me a VST3 flanger plugin. You have 24 hours. What do you do? (brainstorming in fours?)
1. What we'll create: plugin demo
1. Prerequisites for working with the code (building the plugin): Getting Started section of the repo (help). Codespaces will be faster. Just fork the repo first!
    1. "These are the two commands you should be able to execute"
        `python py/main.py data/guitar_5th.wav`
        `cmake --build --preset default`
    1. Fraunhofer girl story
1. Growth mindset: you can improve on virtually anything, including DSP, Python, C++, JUCE and creating plugins.
1. High-level overview of the plugin creation process
    1. Idea
    1. Research
    1. Design
    1. Prototype
    1. Implementation (the DSP part)
    1. Tweaking parameters/experimentation
    1. Field testing (beta testing, validation): you give the plugin to a representation of your user base
    1. Iteration on the design/implementation
1. Idea
    1. What do you want to create?
    2. Why? How is it useful?
    3. For whom is it useful?
    4. Can I explain the above in plain words?
    1. @Linus, who is the source of ideas at Bogren?
    1. Problem: A client comes to you and says: create me a VST3 flanger plugin. You have 24 hours. What do you do? (brainstorming in fours?)
1. Research
    1. End goal: a design
        1. Design
            1. DSP diagram
            2. Difference equations
            3. Textual description
            4. Literature reference (”We will implement equations X-Y from paper Z”)
    1. Has anyone done it before?
    2. Is there a baseline (a plugin or a piece of code that does a similar thing)?
    3. How to do it (better)?
    4. Literature (books, papers, online blogs, videos & forums) review
        1. Examples of good resources:
            1. Books:
                1. DAFX
            2. Papers
                1. DAFX conference
                2. Audio Engineering Society
                3. Google Scholar
                4. If you don’t have access to a paper, email the authors, they’ll probably eagerly share
            3. Online blogs & videos
                1. TheWolfSound.com
            4. Forums
                1. JUCE forum
                2. KVR developer forum
                3. DSP subreddit
                4. DSP Stack Exchange
                5. DIYStompBoxe
                6. Lines forum
            5. External consultancy
1. Task 1: We do a literature review with the goal of nailing the flanger design
    1. In DAFX we find the flanger description. But it’s not 100% clear and the book references another article.
        1. Slide: Description of the DAFX flanger
        2. Explain input, output, delay, multiplication, addition
    2. It’s good idea to check original sources. We find the description of the flanger in the article by Dattoro.
        1. Slide: Description of the Dattoro flanger
        2. Slide: Derive the difference equation from the one by Dattoro (but check DAFX for reference):
            1. Simpler task first
                - Write out DSP equations "we do"
                    - Empty system
                    - Scaler
                    - Delay by 1
                    - Delay by N
                    - Summer
            1. Mark the input, the output, trace the lines
            2. Say that the feedback is always problematic → introduce a helper variable xh
            3. Now xh is x plus xh delayed by half of the delay line length (mark as D)
            4. Now $y[n] = \text{blend }x_h[n] + \text{feedforward } x_h[m]$, $m = s_\text{LFO}D$, $x_h[n] = x[n] - \text{feedback } xh[n-D/2]$. 
            5. We now have difference equations of the flanger
    3. We could go further but we decide that it’s sufficient for now. There’s nothing indicating that the flanger won’t meet our needs.
    4. Now, we’re ready to implement the prototype!
1. Prototype
    1. Quick creation of the desired effect → To verify that it’s doing the thing we want.
    2. PureData
    3. Max/MSP
    4. Python
    5. Matlab
    6. SuperCollider
    7. Faust
    8. Other?
1. Overview of the repo
3. Task 2: Python prototype
    1. Create the Flanger with a fixed delay in the feedforward path
    2. Add LFO to the Flanger
    3. Test the Flanger on test files
    4. Convert the Flanger into a class with a process_sample() function → this is helpful in the C++ transition → you now have the blueprints of all classes that you need in C++ (FractionalDelayLine, LFO, Flanger)
1. Surprise! Polish sweets!
1. Break 3:00-3:15
1. Linus: How do you approach creating plugins at Bogren
1. Implementation (the DSP part)
    1. Technologies available
        1. C++
            1. with JUCE
        2. JavaScript?
        3. C?
        4. Rust?
        5. ???
    2. Start with mono first
    3. Disregard smoothing initially
    4. Focus on correctness, ignore optimization
        1. Who cares if you have the fastest plugin out there if it does not fulfill its job
    5. No GUI (use GenericAudioProcessorEditor)
    6. Verify that the end-2-end plugin output is the same as the prototype’s
1. Task 3: C++ implementation
    1. Use audio-plugin-template
        1. Treat warnings as errors
    2. Commit early, commit often (but double-check what you commit)
    3. Use End-2-End unit tests (wolfsound-dsp-utils)
    4. Don’t be afraid of writing pseudocode
    5. Use juce::juce_dsp structure for easy composability
        1. process(Context)
        2. processSample()
        3. prepare()
        4. reset()
        5. Allows easy channel duplication and processor composability (should you need a preprocessing stage or similar) with provided JUCE processors.
    6. Implement Flanger.h without the LFO first
        1. You can put all in a header
        2. Start with constructor or processSample. 
        3. You can make it a template on SampleType or create an alias for float or use floats.
        4. Fix the parameters in the constructor first
        5. Make `processSample(SampleType input)` return `input` to verify that all is working in the end-2-end test (you get the same output as input)
    7. Make the end-2-end test produce the same result as fixed-delay Python code
1. Tweaking parameters/experimentation
    1. You may consider having “dev” parameters and “user” parameters; dev parameters will be fixed before releasing the plugin
        1. Example: cutoff of the LPF in preprocessing
    2. Feel free to explore! Widen the “allowed” range of parameters, make some parameters unrealistic, etc.
        1. “Model bending” in electronics and VA modeling
        2. In theory, Flanger should have LFO rate of 0.1-1 Hz. In practice, you can freely experiment.
1. Task 4
    1. Add an LFO (e.g., juce::Oscillator) and check again the end-2-end test with Python code
    2. Make parameters (LFO frequency) adjustable
        1. Create a Parameters struct
        2. Create a setter for the parameters
        3. Set the parameters in processBlock
        4. Create an AudioParameterValueTreeState
        5. Add the LFO frequency parameter to the plugin
        6. Return a GenericAudioProcessorEditor in the Editor (you’re just working on the DSP part after all)
    3. (Add parameter smoothing but there are none to smooth here)
    4. Make stereo using JUCE’s ProcessorDuplicator
1. Field testing (beta testing, validation): you give the plugin to a representation of your user base
    1. in the worst case, it may be just yourself
    1. @Linus, how do you test your plugins?
2. Iteration on the design/implementation
    1. Optimization
1. What we did not cover:
    1. Business side of plugin creation
        1. Will my plugin sell?
        2. Packaging for distribution
        3. Selling
        4. Distribution
    2. Code optimization (tuning)
    3. Presets
    4. Undo & redo
1. Your next steps
    1. DSP Pro course
    1. DSP Pro discount
    1. JUCE online course -> my talk tomorrow
1. Thank you! Feedback: jan.wilczek@thewolfsound.com
1. Organizers' announcement
