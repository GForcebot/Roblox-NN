local oldtime = DateTime.now():ToLocalTime()
local colorcodes = {1,2,3,5,6,9,11,12,18,21,22,23,24,25,26,27,28,29,36,37,38,39,40,41,42,43,44,45,47,48,49,50,100,101,102,103,104,105,106,107,108,110,111,112,113,115,116,118,119,120,123,124,125,126,127,128,131,133,134,135,136,137,138,140,141,143,145,146,147,148,149,150,151,153,154,157,158,168,176,179,179,180,190,191,193,194,195,196,198,200,208,209,210,211,212,213,216,217,218,219,220,221,222,223,224,225,226,232,268,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,344,345,346,347,348,349,350,351,352,354,355,356,357,358,359,360,361,362,363,364,365,1001,1002,1003,1004,1005,1006,1007,1007,1008,1009,1010,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032}
--Neural Network originally made by ChickenSauceSandwich, Discord: Bald man with no hair#8606
--edited by me, GForcebot, Discord: G Kitteh Cat#7884
local NeuralNetwork = {}
function bool2int(bool)
	if bool == true then
		return 1
	else
		return 0
	end
end
local learningRate = .0008
--sigmoid activation function
function sigmoid(activation)
	return 1.0/(1.0+math.exp(-activation))
end

function initNeuron(inputs)
	local neuron = {weights = {}, inputs = {}, activation = 0, delta = 0}

	--initialize input weights 
	for w=1,inputs do
		table.insert(neuron.weights, math.random()*(1-(-1)) - 1)
	end

	--initialize bias weight
	table.insert(neuron.weights, 0)

	return neuron
end

function getActivation(neuron, activationf)
	local activation = neuron.weights[#neuron.weights]

	for w=1,#neuron.weights - 1 do
		activation += neuron.inputs[w] * neuron.weights[w]
	end

	if activationf=="sigmoid" then
		activation = sigmoid(activation)
	elseif activationf=="tanh" then
		activation = math.tanh(activation)
	elseif activationf=="LeakyReLU" then
		activation = math.max(activation * 0.01, activation)
	elseif activationf=="ReLU" then
		activation  = math.max(0,activation)
	end

	return activation
end

--get slope of activation
function transferDerivative(activationf, activation)
	if activationf=="sigmoid" then
		activation = sigmoid(activation) * (1 - sigmoid(activation))
	elseif activationf=="tanh" then
		activation = 1 - math.tanh(activation)^2
	elseif activationf=="LeakyReLU" then
		if activation < 0 then
			activation = 0.01
		else
			activation = 1
		end
	elseif	activationf=="ReLU" then
		if activation > 0 then
			return 1
		else
			return 0
		end 
	else
		activation = 1
	end

	return activation
end
local activationFuncs = {"sigmoid","ReLU","ReLU","ReLU"}
--calculates network output
function propogateForward(input)
	local oldInput = {}
	for l,layer in pairs(NeuralNetwork) do
		local newInput = {}
		for n,neuron in pairs(layer) do
			if #neuron.inputs > 0 then neuron.inputs = {} end

			if l == 1 then
				table.insert(neuron.inputs, input[n])
			else
				neuron.inputs = oldInput
			end

			--get activation
			local activation = getActivation(neuron,activationFuncs[l])
			neuron.activation = activation
			table.insert(newInput, activation)
		end
		oldInput = newInput
		newInput = {}
	end
	return oldInput
end
--calculates the error of the network
function propogateBackwards(label)
	local lastLayer = {}
	for l=#NeuralNetwork,1,-1 do
		local losses = {}
		if l ~= #NeuralNetwork then
			for n,neuron in pairs(NeuralNetwork[l]) do
				--calculate loss of hidden neurons
				local loss = 0
				for pn,pneuron in pairs(lastLayer) do
					loss += pneuron.weights[n] * pneuron.delta
				end
				table.insert(losses,loss)
			end
		else
			for n,neuron in pairs(NeuralNetwork[l]) do
				table.insert(losses,neuron.activation - label[n])
			end
		end

		for n,neuron in pairs(NeuralNetwork[l]) do
			neuron.delta = losses[n] * transferDerivative(activationFuncs[l], neuron.activation)
		end

		losses = {}
		lastLayer = NeuralNetwork[l]
	end
end

--function to update neuron weights
function updateNetwork()
	for l,layer in pairs(NeuralNetwork) do
		for n,neuron in pairs(layer) do
			for i,input in pairs(neuron.inputs) do
				neuron.weights[i] -= learningRate * neuron.delta * neuron.inputs[i]
			end

			--update bias weight
			neuron.weights[#neuron.weights] -= learningRate * neuron.delta
		end
	end
end
--input layer
local layers = {}
for i = 1,3 do
	local neur = initNeuron(1)
	table.insert(layers,neur)
end
table.insert(NeuralNetwork, layers)
--hidden
local layers = {}
for i = 1,7 do
	local neuron = {}
	neuron = initNeuron(3)
	table.insert(layers,neuron)
end
table.insert(NeuralNetwork,layers)
local layers = {}
for i = 1,7 do
	local neuron = {}
	neuron = initNeuron(7)
	table.insert(layers,neuron)
end
table.insert(NeuralNetwork,layers)
--output
local layers = {}
for i = 1,3 do
	local neuron = initNeuron(7) 
	table.insert(layers,neuron)
end
table.insert(NeuralNetwork,layers)

local debris = game:GetService("Debris")
local max = 1016.8157
local worldmodel = Instance.new("WorldModel",script)
local block = Instance.new("SpawnLocation",worldmodel)
block.Enabled = false
block.Color = Color3.new(.5,.5,.5)
local clors = block.Color
block.Material = Enum.Material.SmoothPlastic
block.Size = Vector3.one
local display = Instance.new("Part",script)
display.Material = Enum.Material.SmoothPlastic

local surfacegui = Instance.new("SurfaceGui",display)
display.Size = Vector3.new(5,3,0)
display.Anchored = true
surfacegui.Face = Enum.NormalId.Back
text = Instance.new("TextBox",surfacegui)
text.Font = Enum.Font.Code
text.TextStrokeTransparency = 0
text.MultiLine = true
text.Size = UDim2.new(1,0,1,0)
text.BackgroundTransparency = 1
text.TextScaled = true

text.Text = ""
local color
task.spawn(function()
	while task.wait() do
		display.CFrame =  owner.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,-5)
		block.CFrame =  owner.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-5)
		local raycast = workspace:Raycast(block.Position,block.CFrame.LookVector*10000)
		if raycast and raycast.Instance then
			color =  raycast.Instance.Color
			target = true
		else
			color = Color3.new(1, 1, 1)
			target = false
		end
		--text.Text = string.format("%.2f",bright)
		--display.Color = Color3.new(bright,bright,bright)
		--text.TextColor3 = Color3.new(0,1, 0)
	end

end)
--training 1
	while task.wait() do
		colors = colorcodes[math.random(1,#colorcodes)]
	local output = propogateForward({BrickColor.new(colors).Color.R,BrickColor.new(colors).Color.G,BrickColor.new(colors).Color.G})
	propogateBackwards({ color.R, color.G, color.B})
		updateNetwork()
		--display.Color = Color3.new(output[1],output[2],output[3])
		--display.BrickColor = BrickColor.new(clors)
		text.TextColor3 = Color3.new(0,1, 0)
		block.BrickColor = BrickColor.new(Color3.new(output[1],output[2],output[3]))
	text.Text =  string.format("Color:%s \n%.2f%% Right",BrickColor.new(Color3.new(output[1],output[2],output[3])).Name ,math.abs(100-(math.abs(((( color.R+ color.G+ color.B)/3)-((output[1]+output[2]+output[3])/3))/(( color.R+ color.G+ color.B)/3))*100)))
		if math.floor((( color.R-output[1])/ color.R)*100) == 0  and math.floor((( color.G-output[2])/ color.G)*100) == 0 and math.floor((( color.B-output[3])/ color.B)*100) == 0 then
			print("done")
			print(string.format("%.1f minutes,%.2f seconds, %d miliseconds",((DateTime.now():ToLocalTime().Millisecond-oldtime.Millisecond)*0.001)*0.0166666667,(DateTime.now():ToLocalTime().Millisecond-oldtime.Millisecond)*0.001,(DateTime.now():ToLocalTime().Millisecond-oldtime.Millisecond)))
			break
		end
	end

for i = 1,10 do
	wait(2)
	print(10-i)
end
local tweenservice = game:GetService("TweenService")
local tweeninfo = TweenInfo.new(1.505,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out,0,false,0)
--training 2
while task.wait() do
	local output = propogateForward({block.Color.R,block.Color.G,block.Color.B})
	propogateBackwards({ color.R, color.G, color.B})
	updateNetwork()
	block.Color = Color3.new(output[1],output[2],output[3])
	text.Text =  string.format("Color:%s \n%.2f%% Right",BrickColor.new(Color3.new(output[1],output[2],output[3])).Name ,math.abs(100-((((( color.R+ color.G+ color.B)/3)-((output[1]+output[2]+output[3])/3))/(( color.R+ color.G+ color.B)/3))*100)))
	if math.floor((( color.R-output[1])/ color.R)*100) == 0  and math.floor((( color.G-output[2])/ color.G)*100) == 0 and math.floor((( color.B-output[3])/ color.B)*100) == 0 then
		break
	end
end
local output = propogateForward({block.Color.R,block.Color.G,block.Color.B})
tween = tweenservice:Create(block,tweeninfo,{Color =Color3.new(output[1],output[2],output[3])})

if target then
	display.BrickColor = BrickColor.White()
	text.Text = string.format("The color is %s.",BrickColor.new(Color3.new(output[1],output[2],output[3])).Name)
else
	display.BrickColor = BrickColor.Red()
	text.Text = "Error: No Target"
end

text.TextColor = BrickColor.new(Color3.new(-output[1],-output[2],-output[3]))


tween:Play()
tween.Completed:Wait()
tween:Pause()
