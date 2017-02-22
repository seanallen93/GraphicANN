/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// RELEASE NOTES
//---------------------------------------------------------------------------------------------------------------------------
/*
Filename: ANN_v1.1.5.pde
 Version: 1.1.5 (LoadSave)
 Author: Sean Allen
 Last Modified: 2/13/17
 
To Do:
- Make file load/save. <----
- Make Import function for training sets.
- Cortex connections and mapping
- Zoom in/out + translate
- Neuron modification screen
- External live data I/O
*/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



// New neural network variables.
NeuralNetwork[] NN; 
 
int rows = 10;                  
int columns = 4;     
int newRows = 10;
int newColumns = 4;
float learningConstant = 0.0001;        
float learningThreshold = .01;
boolean BP_State = true;              // Toggle for backpropagation
char feedDirection = 'F';             // Feedforward('F'): Adjust weights from the back to the front. 
                                      // Feedback('B'): Adjust weights from the front to the back. 
float neuronRange = 40;
boolean firstCyle = true;
float fuzz = 0.000;
float fuzzLow = -fuzz;
float fuzzHigh = fuzz;

// Menu variables
int option = 0;
final int PLAY = 0;
final int PAUSE = 1;
final int TRAIN = 2;



// File save variables
Table saveTable;


// Training variables
float q1 = 1;
float q2 = 1;
float answer;
float guess;
float guess2;
float error;

int input1Row = 4;
int input1Column = 0;

int input2Row = 9;
int input2Column = 0;

int outputRow = 4;
int outputColumn = 3;

// Lobe variable
int net_MAX = 9;
int netCount = 2;

void settings()
{
  size(1300, 900);
}

void setup()
{ 
  trainingTable = loadTable("Pier1.csv", "header");
  
  
  setupUI();
  
  // Create save table
  saveTable = new Table();
  
  // Create network
  NN = new NeuralNetwork[net_MAX];

  // Populate the network
  NN[0] = new NeuralNetwork(rows, columns, learningConstant, learningThreshold, BP_State);
  NN[1] = new NeuralNetwork(rows, columns, learningConstant, learningThreshold, BP_State);
  
  NN[0].populate(150, 150, 27);
  NN[1].populate(150, 150, 27);
}

void draw()
{
  background(155);
  
  
  switch(option)
  {
  case PLAY:
    if(Training == true)
      NN[net].trainingState = true;
    else
      NN[net].trainingState = false;
      
    drawSynapse();
    //fuzzInjection(100);
    processNetwork(net);
    //neuronTrainAddition(q1, q2, net);
    neuronTrainMultiplication(q1, q2, net);
    NN[net].drawNeurons();
    
    DEBUG();
    break;  

  case PAUSE:
    stroke(255);
    textSize(24);
    text("PAUSED", width - 150, 40);
    drawSynapse();
    NN[net].staticDrawNetwork();
    DEBUG();
    break;
    
  case TRAIN:
    netTrainTable(trainingTable);
    option = PAUSE;
    break;
  }
}

void processNetwork(int n) {
  NN[n].neuron[input1Row][input1Column].output = q1;
  NN[n].neuron[input2Row][input2Column].output = q2;
  NN[n].processNeurons(error);
}


////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////

void drawSynapse()
{
  strokeWeight(0.5);

  for (int i = 0; i <= NN[net].nRows - 1; i++) // Scan rows
  {
    for (int ii = 0; ii < NN[net].nColumns - 1; ii++) // Scan columns
    {
      float thickness[] = new float[3];  // Array for setting the thickness of each line based off of its weight
      thickness[0] = NN[net].neuron[i][ii].weights[0];
      thickness[1] = NN[net].neuron[i][ii].weights[1];
      thickness[2] = NN[net].neuron[i][ii].weights[2];
      int m = 1;  // Multiplier for line size.
      int synapseHue;
      
      //stroke(255);
      // CoNN[net]ections for the first row.
      if (i < 1)
      {
        
        strokeWeight(abs(thickness[1] * m));
        if(thickness[1] >= 0)
          synapseHue = 0;
        else
          synapseHue = 255;
        stroke(synapseHue);
        line(NN[net].neuron[i][ii].x, NN[net].neuron[i][ii].y, NN[net].neuron[i][ii + 1].x, NN[net].neuron[i][ii + 1].y); // Neuron in front
        strokeWeight(abs(thickness[2] * m));
        if(thickness[2] >= 0)
          synapseHue = 0;
        else
          synapseHue = 255;
        stroke(synapseHue);
        line(NN[net].neuron[i][ii].x, NN[net].neuron[i][ii].y, NN[net].neuron[i + 1][ii + 1].x, NN[net].neuron[i + 1][ii + 1].y); // Neuron below
      }
      // CoNN[net]ections for the last row.
      else if (i >= NN[net].nRows - 1)
      {
        strokeWeight(abs(thickness[0] * m));
        if(thickness[0] >= 0)
          synapseHue = 0;
        else
          synapseHue = 255;
        stroke(synapseHue);
        line(NN[net].neuron[i][ii].x, NN[net].neuron[i][ii].y, NN[net].neuron[i][ii + 1].x, NN[net].neuron[i][ii + 1].y); // Neuron in front
        strokeWeight(abs(thickness[1] * m));
        if(thickness[1] >= 0)
          synapseHue = 0;
        else
          synapseHue = 255;
        stroke(synapseHue);
        line(NN[net].neuron[i][ii].x, NN[net].neuron[i][ii].y, NN[net].neuron[i - 1][ii + 1].x, NN[net].neuron[i - 1][ii + 1].y); // Neuron above
      }
      // CoNN[net]ecting the rows inbetween.
      if (i >= 1 && i < NN[net].nRows - 1)
      {
        strokeWeight(abs(thickness[0] * m));
        if(thickness[0] >= 0)
          synapseHue = 0;
        else
          synapseHue = 255;
        stroke(synapseHue);
        line(NN[net].neuron[i][ii].x, NN[net].neuron[i][ii].y, NN[net].neuron[i - 1][ii + 1].x, NN[net].neuron[i - 1][ii + 1].y); // Neuron above
        strokeWeight(abs(thickness[1] * m));
        if(thickness[1] >= 0)
          synapseHue = 0;
        else
          synapseHue = 255;
        stroke(synapseHue);
        line(NN[net].neuron[i][ii].x, NN[net].neuron[i][ii].y, NN[net].neuron[i][ii + 1].x, NN[net].neuron[i][ii + 1].y); // Neuron in front
        strokeWeight(abs(thickness[2] * m));
        if(thickness[2] >= 0)
          synapseHue = 0;
        else
          synapseHue = 255;
        stroke(synapseHue);
        line(NN[net].neuron[i][ii].x, NN[net].neuron[i][ii].y, NN[net].neuron[i + 1][ii + 1].x, NN[net].neuron[i + 1][ii + 1].y); // Neuron below
      }
    }
  }
}

// Reset the network with current parameters
public void reset() {
  println("Network: " + net + " has been reset");
  // Get network parameters
  int r = NN[net].nRows;
  int c = NN[net].nColumns;
  float lc = NN[net].LC;
  float lt = NN[net].LT;
  boolean bp = NN[net].BP_State;
  // Create new network with original network parameters
  NN[net] = new NeuralNetwork(r, c, lc, lt, bp);

  // Populate the network
  NN[net].populate(150, 150, 27);
}

  
public void addNetwork(int theValue)
{
  println("addNetwork button pressed");
 
  // Create new tab
  String tabName = "Network " + netCount;
  cp5.addTab(tabName)
     .setColorBackground(color(0, 0, 0))
     .setColorLabel(color(255))
     .setColorActive(color(0, 180, 255))
     ;
     
  cp5.getTab(tabName)
     .activateEvent(true)
     .setId(netCount - 1)
     ;
  // Keep inputs and outputs within the new network
  if(input1Row >= newRows)
    input1Row = newRows - 1;
  if(input1Column >= newColumns)
    input1Column = newColumns - 1;
  if(input2Row >= newRows)
    input2Row = newRows - 1;
  if(input2Column >= newColumns)
    input2Column = newColumns - 1;
  if(outputRow >= newRows)
    outputRow = newRows - 1;
  if(outputColumn >= newColumns)
    outputColumn = newColumns - 1;
  
  // Create new network
  newNetwork(newRows, newColumns, learningConstant, learningThreshold, BP_State);
  
}

void newNetwork(int rows_, int columns_, float learningConstant_, float learningThreshold_, boolean BP_State_)
{
  NN[netCount - 1] = new NeuralNetwork(rows_, columns_, learningConstant_, learningThreshold_, BP_State_);
  NN[netCount - 1].populate(150, 150, 27);
  
  infoX = outputRow;
  infoY = outputColumn;
  
  netCount++;
  
  net = netCount - 2;
}

//-----------------------------------------------------------------------
// Unfinished functions
//-----------------------------------------------------------------------

float fuzzMod = .1;
int staticCycles = 0;
float lastMean = 0;
float lastError = 0;
int fuzzCycleThreshold = 100;

void fuzzInjection(float num, float mod) 
{
  fuzzMod = mod;
  if(NN[net].actMean() == lastMean)
  staticCycles++;
  if(error == lastError)  
    staticCycles++;
  
  if(NN[net].actMean() != lastMean)
    staticCycles = 0; 
  if(error != lastError) 
    staticCycles = 0;
  
  if(staticCycles >= fuzzCycleThreshold)
  {
    float fuzz = num / (random(-100, 100) * fuzzMod);
    for(int i = 0; i < NN[net].nRows; i++)
      for(int ii = 0; ii < NN[net].nColumns; ii++)
       NN[net].neuron[i][ii].fuzz = fuzz; //fuzz;
  }
  
  lastError = error;
  lastMean = NN[net].actMean();
}
    
  