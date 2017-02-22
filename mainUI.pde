/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
Filename: mainUI.pde
Version: 1.1.0
Author: Sean Allen
Last Modified: 2/13/17
*/
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import controlP5.*;

ControlP5 cp5;
Chart activityGraph, weightGraph1, weightGraph2, weightGraph3;

// Current selected network
int net = 0;

// Selected neuron coordinates
int infoX, infoY; // Position of neuron to display info about.
float mX, mY;     // Mouse position
int selectedX = 0; int selectedY = 0; // Coordinates for last selected neuron.

// Button variables
int buttonSize = 20;     // Diameter of rect
int buttonX = 420;
int buttonY = 40;
boolean rectOver = false;

// Text field variables
int inText1X = 500; // Text field positions
int inText1Y = 200;
int inText2X = 600;
int inText2Y = 200;
int in1Row_textX = 500;
int in1Column_textX = 600;
int in1_textY = 350;
int in2Row_textX = 500;
int in2Column_textX = 600;
int in2_textY = 400;
int outRow_textX = 500;
int outColumn_textX = 600;
int out_textY = 450;
int LC_textX = 500;
int LC_textY = 300;
int newRow_textX = 500;
int newColumn_textX = 600;
int new_textY = 500;
int inTextSizeX = 80; // Text field sizes
int inTextSizeY = 20;
int save_textX = 20;
int save_textY = 530;

// Toggle variables
boolean Training = true;



//----------------------------------------------------------------------------------------------
// UI setup
//----------------------------------------------------------------------------------------------
void setupUI()
{
  cp5 = new ControlP5(this); //Setup chart function
  PFont font = createFont("arial",10);
  
  //----------------------------------------------------------------------------------------------
  // Tabs
  //----------------------------------------------------------------------------------------------
  
  cp5.addTab("Network 2")
     .setColorBackground(color(0, 0, 0))
     .setColorLabel(color(255))
     .setColorActive(color(0, 180, 255))
     ;
     
  // if you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)
  
  cp5.getTab("default")
     .activateEvent(true)
     .setLabel("Network 1")
     .setId(0)
     ;

  cp5.getTab("Network 2")
     .activateEvent(true)
     .setId(1)
     ;
 
  
  //----------------------------------------------------------------------------------------------
  // Monitors
  //----------------------------------------------------------------------------------------------
  
  // Neruon activity monitor 
  activityGraph = cp5.addChart("Neuron Activation")
               .setPosition(500, 20)
               .setSize(200, 150)
               .setRange(-100, 100)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               .setStrokeWeight(1.5)
               .setColorCaptionLabel(color(255))
               ;
  activityGraph.addDataSet("activity");
  activityGraph.setData("activity", new float[100]);             
  
  // Neuron weight monitors
  weightGraph1 = cp5.addChart("Neuron Weight 1")
               .setPosition(720, 20)
               .setSize(60, 30)
               .setRange(-10, 10)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               .setStrokeWeight(1.5)
               .setColorCaptionLabel(color(255))
               ;
  weightGraph1.addDataSet("weight1");
  weightGraph1.setData("weight1", new float[100]);
  
  weightGraph2 = cp5.addChart("Neuron Weight 2")
               .setPosition(720, 75)
               .setSize(60, 30)
               .setRange(-10, 10)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               .setStrokeWeight(1.5)
               .setColorCaptionLabel(color(255))
               ;
  weightGraph2.addDataSet("weight2");
  weightGraph2.setData("weight2", new float[100]);
  
  weightGraph3 = cp5.addChart("Neuron Weight 3")
               .setPosition(720, 130)
               .setSize(60, 30)
               .setRange(-10, 10)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               .setStrokeWeight(1.5)
               .setColorCaptionLabel(color(255))
               ;
  weightGraph3.addDataSet("weight3");
  weightGraph3.setData("weight3", new float[100]);
  
  cp5.getController("Neuron Activation").moveTo("global");
  cp5.getController("Neuron Weight 1").moveTo("global");
  cp5.getController("Neuron Weight 2").moveTo("global");
  cp5.getController("Neuron Weight 3").moveTo("global");
  
  //----------------------------------------------------------------------------------------------
  // Text inputs
  //----------------------------------------------------------------------------------------------
  cp5.addTextfield("Input 1")  // Question 1
     .setPosition(inText1X, inText1Y)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
  
  // Question 2
  cp5.addTextfield("Input 2") 
     .setPosition(inText2X, inText2Y)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(false)
     .setColor(color(255,0,0))
     ;
  
  // Input 1 Coordinates
  cp5.addTextfield("Input 1 Row")
     .setPosition(in1Row_textX, in1_textY)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
  cp5.addTextfield("Input 1 Column")
     .setPosition(in1Column_textX, in1_textY)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(false)
     .setColor(color(255,0,0))
     ;
     
  // Input 2 Coordinates
  cp5.addTextfield("Input 2 Row")
     .setPosition(in2Row_textX, in2_textY)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
  cp5.addTextfield("Input 2 Column")
     .setPosition(in2Column_textX, in2_textY)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(false)
     .setColor(color(255,0,0))
     ;
     
  // Output Coordinates
  cp5.addTextfield("Output Row")
     .setPosition(outRow_textX, out_textY)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
  cp5.addTextfield("Output Column")
     .setPosition(outColumn_textX, out_textY)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(false)
     .setColor(color(255,0,0))
     ;
  // Learning Constant
  cp5.addTextfield("Learning Constant")
     .setPosition(LC_textX, LC_textY)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(false)
     .setColor(color(255,0,0))
     ;
     
  // Output Coordinates
  cp5.addTextfield("New Net Rows")
     .setPosition(newRow_textX, new_textY)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
  cp5.addTextfield("New Net Columns")
     .setPosition(newColumn_textX, new_textY)
     .setSize(inTextSizeX, inTextSizeY)
     .setFont(font)
     .setFocus(false)
     .setColor(color(255,0,0))
     ;
     
  // Save file
  cp5.addTextfield("Save Filename")
     .setPosition(save_textX, save_textY)
     .setSize(200, inTextSizeY)
     .setFont(font)
     .setFocus(false)
     .setColor(color(255,0,0))
     ;
  
  cp5.getController("Input 1").moveTo("global");
  cp5.getController("Input 2").moveTo("global");
  cp5.getController("Input 1 Row").moveTo("global");
  cp5.getController("Input 1 Column").moveTo("global");
  cp5.getController("Input 2 Row").moveTo("global");
  cp5.getController("Input 2 Column").moveTo("global");
  cp5.getController("Output Row").moveTo("global");
  cp5.getController("Output Column").moveTo("global");
  cp5.getController("Learning Constant").moveTo("global");
  cp5.getController("New Net Rows").moveTo("global");
  cp5.getController("New Net Columns").moveTo("global");
  cp5.getController("Save Filename").moveTo("global");
  //----------------------------------------------------------------------------------------------
  // Buttons
  //----------------------------------------------------------------------------------------------
  cp5.addButton("reset")  // Reset the network
     .setValue(0)
     .setPosition(500, 270)
     .setSize(100,19)
     ;
  textFont(font);
  
  cp5.addButton("addNetwork")  // Create a new network
     .setValue(0)
     .setPosition(620, 270)
     .setSize(100,19)
     ;
  textFont(font);
  
  cp5.addButton("Save")  // Save the network
     .setValue(0)
     .setPosition(230, 530)
     .setSize(100,19)
     ;
  textFont(font);
  
  cp5.getController("reset").moveTo("global");
  cp5.getController("addNetwork").moveTo("global");
  cp5.getController("Save").moveTo("global");
  //----------------------------------------------------------------------------------------------
  // Toggles
  //----------------------------------------------------------------------------------------------
  cp5.addToggle("Training")
     .setPosition(700, 200)
     .setSize(50,20)
     ;
     
  cp5.getController("Training").moveTo("global");
  
  //----------------------------------------------------------------------------------------------
  // Sliders
  //----------------------------------------------------------------------------------------------  
/*  cp5.addSlider("learningConstant")
     .setPosition(500,330)
     .setRange(0,1)
     ;

  cp5.getController("learningConstant").moveTo("global");
*/  
//--------------------------------------------------------------------------------------------------  
}


//////////////////////////////////////////////////////////////
// Input and Output
//////////////////////////////////////////////////////////////

void setTextFocusFalse()
{
  cp5.get(Textfield.class,"Input 1").setFocus(false);
      cp5.get(Textfield.class,"Input 1 Row").setFocus(false);
      cp5.get(Textfield.class,"Input 1 Column").setFocus(false);
      cp5.get(Textfield.class,"Input 2").setFocus(false);
      cp5.get(Textfield.class,"Input 2 Row").setFocus(false);
      cp5.get(Textfield.class,"Input 2 Column").setFocus(false);
      cp5.get(Textfield.class,"Output Row").setFocus(false);
      cp5.get(Textfield.class,"Output Column").setFocus(false);
      cp5.get(Textfield.class,"Learning Constant").setFocus(false);
      cp5.get(Textfield.class,"New Net Rows").setFocus(false);
      cp5.get(Textfield.class,"New Net Columns").setFocus(false);
      cp5.get(Textfield.class,"Save Filename").setFocus(false);
}

// The DEBUG() function outputs debugging information for a given neuron.
void DEBUG()
{
  mX = mouseX;
  mY = mouseY;

  // Select neuron to view.
  if (mousePressed)
  {    
    // Check to see if mouse clicked over a neuron.
    for (int i = 0; i < NN[net].nRows; i++)
    {
      for (int ii = 0; ii < NN[net].nColumns; ii++)
      {
        
        // Get coordinate and size values of the neuron.
        int nX = NN[net].neuron[i][ii].x;
        int nY = NN[net].neuron[i][ii].y;
        int nSize = NN[net].neuron[1][1].bodySize;
        // If the mouse is over the neuron, display that neurons information.
        if (overNeuron(nX, nY, nSize) == true)
        {
          infoX = i;
          infoY = ii;
          
          NN[net].neuron[selectedX][selectedY].isSelected = false;
          selectedX = i;
          selectedY = ii;
          
          NN[net].neuron[i][ii].isSelected = true;
        }
      }
    }
    // Check to see it the mouse clicked over a text box and toggle focus.
    if(overRect(inText1X, inText1Y, inTextSizeX, inTextSizeY)) // Input 1
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"Input 1").setFocus(true);
    }
    if(overRect(inText2X, inText2Y, inTextSizeX, inTextSizeY)) // Input 2
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"Input 2").setFocus(true);
    }
    if(overRect(in1Row_textX, in1_textY, inTextSizeX, inTextSizeY)) // Input 1 Row
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"Input 1 Row").setFocus(true);
    }
    if(overRect(in1Column_textX, in1_textY, inTextSizeX, inTextSizeY)) // Input 1 Column
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"Input 1 Column").setFocus(true);
    }
    if(overRect(in2Row_textX, in2_textY, inTextSizeX, inTextSizeY)) // Input 2 Row
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"Input 2 Row").setFocus(true);
    }
    if(overRect(in2Column_textX, in1_textY, inTextSizeX, inTextSizeY)) // Input 2 Column
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"Input 2 Column").setFocus(true);
    }
    if(overRect(outRow_textX, out_textY, inTextSizeX, inTextSizeY)) // Output Row
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"Output Row").setFocus(true);
    }
    if(overRect(outColumn_textX, out_textY, inTextSizeX, inTextSizeY)) // Output Column
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"Output Column").setFocus(true);
    }
    if(overRect(LC_textX, LC_textY, inTextSizeX, inTextSizeY)) // Learning Constant
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"Learning Constant").setFocus(true);
    }
    if(overRect(newRow_textX, new_textY, inTextSizeX, inTextSizeY)) // New Net Rows
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"New Net Rows").setFocus(true);
    }
    if(overRect(newColumn_textX, new_textY, inTextSizeX, inTextSizeY)) // New Net Columns
    {
      setTextFocusFalse();
      cp5.get(Textfield.class,"New Net Columns").setFocus(true);
    }
    if(overRect(save_textX, save_textY, inTextSizeX, 200)) // Network Save Filename
    {
      saveNetwork();
      setTextFocusFalse();
      cp5.get(Textfield.class,"Save Filename").setFocus(true);
    }
  }

  // Display information about the neuron.
  debugText();

  // Pass information to the charts. 
  activityGraph.push("activity", NN[net].neuron[infoX][infoY].output * 13); // Create Chart based on the selected neuron's output.
  weightGraph1.push("weight1", NN[net].neuron[infoX][infoY].weights[0]); // Create Chart based on the weight of theselected neuron's first input.
  weightGraph2.push("weight2", NN[net].neuron[infoX][infoY].weights[1]); // Create Chart based on the weight of theselected neuron's second input.
  weightGraph3.push("weight3", NN[net].neuron[infoX][infoY].weights[2]); // Create Chart based on the weight of theselected neuron's third input.
}

boolean overNeuron(int x, int y, int diameter) 
  {
    float disX = x - mouseX;
    float disY = y - mouseY; 
    if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } 
    else
      return false;
  }
  
  boolean overRect(int x, int y, int sizeX, int sizeY)  
  {
    if (mouseX >= x && mouseX <= x + sizeX && 
        mouseY >= y && mouseY <= y + sizeY) {
      return true;
    } 
    else
    {
      return false;
    }
  }

// Toggle play and pause with space bar.
void keyPressed() 
{
  // Pause and play using spacebar
  if (key == ' ')
  {
    if (option == PLAY)
    {
      option = PAUSE;
    } else if (option == PAUSE)
    {
      option = PLAY;
    }
  }
  if (key == 't')
  {
    option = TRAIN;
  }
  if (key == 's')
  {
    saveNetwork();
  }
}

void controlEvent(ControlEvent theEvent) {
  // Tab event controller
  if (theEvent.isTab()) 
  {
    net = theEvent.getTab().getId();
  }
    
  if(theEvent.isAssignableFrom(Textfield.class)) {
    // Console debug output.
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
    // Learning Constant event controller
    if(theEvent.getName() == "Learning Constant")
    {
      String inputString = theEvent.getStringValue();
      learningConstant = float(inputString);
      NN[net].LC = learningConstant;
      for(int i = 0; i < NN[net].nRows; i++) // Update the LC of each neuron 
        for(int ii = 0; ii < NN[net].nColumns; ii++)
          NN[net].neuron[i][ii].LC = learningConstant;
    }
    // Input 1 event controller
    if(theEvent.getName() == "Input 1")
    {
      String inputString = theEvent.getStringValue();
      q1 = int(inputString);
    }
    // Input 2 event controller
    if(theEvent.getName() == "Input 2")
    {
      String inputString = theEvent.getStringValue();
      q2 = int(inputString);
    }
    // Input 1 Row event controller
    if(theEvent.getName() == "Input 1 Row")
    {
      String inputString = theEvent.getStringValue();
      input1Row = int(inputString) - 1;
    }
    // Input 1 Column event controller
    if(theEvent.getName() == "Input 1 Column")
    {
      String inputString = theEvent.getStringValue();
      input1Column = int(inputString) - 1;
    }
    // Input 2 Row event controller
    if(theEvent.getName() == "Input 2 Row")
    {
      String inputString = theEvent.getStringValue();
      input2Row = int(inputString) - 1;
    }
    // Input 2 Column event controller
    if(theEvent.getName() == "Input 2 Column")
    {
      String inputString = theEvent.getStringValue();
      input2Column = int(inputString) - 1;
    }
    // Output Row event controller
    if(theEvent.getName() == "Output Row")
    {
      String inputString = theEvent.getStringValue();
      outputRow = int(inputString) - 1;
    }
    // Output Column event controller
    if(theEvent.getName() == "Output Column")
    {
      String inputString = theEvent.getStringValue();
      outputColumn = int(inputString) - 1;
    }
    // New Net Rows event controller
    if(theEvent.getName() == "New Net Rows")
    {
      String inputString = theEvent.getStringValue();
      newRows = int(inputString);
    }
    // New Net Columns event controller
    if(theEvent.getName() == "New Net Columns")
    {
      String inputString = theEvent.getStringValue();
      newColumns = int(inputString);
    }
    // Save Filename event controller
    if(theEvent.getName() == "Save Filename")
    {
      saveFilename = theEvent.getStringValue();
    }
  }
}


void debugText()
{
  stroke(255);
  textSize(12);
  // Mouse coordinates
  text("Mouse X: " + mX, 20, 880);
  text("Mouse Y: " + mY, 150, 880);
  
  // Neuron information
  text("Neuron (" + infoX + "," + infoY + ")", 20, 40);
  text("input[0]: " + NN[net].neuron[infoX][infoY].lastInput[0], 20, 60);
  text("weight[0]: " + NN[net].neuron[infoX][infoY].weights[0], 150, 60);
  text("Output: " + NN[net].neuron[infoX][infoY].output, 280, 60);
  text("input[1]: " + NN[net].neuron[infoX][infoY].lastInput[1], 20, 80);
  text("weight[1]: " + NN[net].neuron[infoX][infoY].weights[1], 150, 80);
  text("input[2]: " + NN[net].neuron[infoX][infoY].lastInput[2], 20, 100);
  text("weight[2]: " + NN[net].neuron[infoX][infoY].weights[2], 150, 100);
  text("HP: " + NN[net].neuron[infoX][infoY].hp, 20, 120);
  text("Exhitation: " + NN[net].neuron[infoX][infoY].activation, 150, 120);
  text("HP Period: " + NN[net].neuron[infoX][infoY].hp_period_cnt, 20, 140);
  text("Hue: " + NN[net].neuron[infoX][infoY].hue, 20, 160);
  if (NN[net].neuron[infoX][infoY].alive)
  { 
    text("Alive", 20, 180);
  }
  if (!NN[net].neuron[infoX][infoY].alive)
  { 
    text("Dead", 20, 180);
  }

  // Back propagation information
  text("Guess: " + guess, 20, 440);
  text("Error: " + error, 150, 440);
  text("Activation: " + NN[net].neuron[infoX][infoY].activation, 280, 440);
  text("Average Act: " + NN[net].actMean(), 280, 460);
  text("Learning Constant: " + learningConstant, 20, 460);
  text("netCount: " + netCount, 20, 480);
  text("NN.length: " + NN.length, 150, 480);
  text("Static Cycles: " + staticCycles, 20, 500);
  
  // Training information
  textSize(24);
  text(q1, 500, 260);
  text("x", 550, 260);
  text(q2, 600, 260);
  text("=", 650, 260);
  text(answer + "(" + NN[net].neuron[outputRow][outputColumn].output + ")", 700, 260);
  
  // I/O Coordinates
  textSize(18);
  text("Learning Constant: " + learningConstant, 600, 315);
  text("Input 1: (" + (input1Row + 1) + ", " + (input1Column + 1) + ")", 700, 365);
  text("Input 2: (" + (input2Row + 1) + ", " + (input2Column + 1) + ")", 700, 415);
  text("Output: (" + (outputRow + 1) + ", " + (outputColumn + 1) + ")", 700, 465);
  text("(" + newRows + ", " + newColumns + ")", 720, 515);
  text("Current Size: (" + NN[net].nRows + ", " + NN[net].nColumns + ")", 500, 565);
  
/*  
  textSize(12);
  if(NN[net].trainingState == false)
    text("Training complete.", 700, 215);
    if(NN[net].trainingState == true)
    text("Training in progress.", 700, 215);
*/
}