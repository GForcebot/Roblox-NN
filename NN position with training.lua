local oldtime = DateTime.now():ToLocalTime()
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
local learningRate = .0003
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
local activationFuncs = {"tanh","ReLU","ReLU","ReLU"}
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
local max = 1000000
local worldmodel = Instance.new("WorldModel",script)
local tweenservice = game:GetService("TweenService")
local tweeninfo = TweenInfo.new(.05,Enum.EasingStyle.Exponential,Enum.EasingDirection.Out,0,false,0)
--task.spawn(function()
--	while task.wait() do
--		local raycast = workspace:Raycast(owner.Character.Head.Position,owner.Character.Head.CFrame.LookVector*1000)
--		if raycast and raycast.Instance then
--			pos = raycast.Position
--		else
--			pos = owner.Character.Head.Position
--		end
--	end
--end)
i = 0

local display = Instance.new("Part",worldmodel)
display.Material = Enum.Material.SmoothPlastic

local surfacegui = Instance.new("SurfaceGui",display)
display.Size = Vector3.new(5,3,0)
display.Anchored = true
surfacegui.Face = Enum.NormalId.Back
text = Instance.new("TextBox",surfacegui)
text.Font = Enum.Font.Code

text.MultiLine = true
text.Size = UDim2.new(1,0,1,0)
text.BackgroundTransparency = 1
text.TextScaled = true

text.Text = ""
local desired
local epoch = 0
local fails = 0
while task.wait() do
	epoch += 1
	desired = owner.Character.HumanoidRootPart.Position
	--desired = Vector3.one*20
	--desired = owner.Character.HumanoidRootPart.Position+(owner.Character.HumanoidRootPart.CFrame.LookVector*math.random(-2,2))
	--desired = Vector3.one*math.random(0,20)
	--desired = Vector3.new(math.random(-1000,1000),math.random(-1000,1000),math.random(-1000,1000))
	--desired = Vector3.new(math.random(-100,100),math.random(-100,100),math.random(-100,100))
	--desired = Vector3.new(math.random(-10,10),math.random(-10,10),math.random(10,10))
	--desired = Vector3.new(math.random(0,20),math.random(0,20),math.random(0,20))
	--desired = Vector3.one
	display.CFrame =  owner.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-5)

	text.TextStrokeTransparency = 0
	--block.Position = Vector3.one*math.random(-100,100)
	--block.Size = Vector3.one*math.random(0,100)
	--1-(desired.X-math.random(-max,max)/desired.X)
	local output = propogateForward({math.random(-max,max),math.random(-max,max),math.random(-max,max)})
	--local output = propogateForward({1-(desired.X-math.random(-max,max)/desired.X),1-(desired.Y-math.random(-max,max)/desired.Y),1-(desired.Z-math.random(-max,max)/desired.Z)})
	--local output = propogateForward({math.random(-max,max)/desired.X,math.random(-max,max)/desired.Y,math.random(-max,max)/desired.Z})
	propogateBackwards({1,1,1})
	updateNetwork()
	local block = Instance.new("SpawnLocation",worldmodel)
	block.Enabled = false
	block.BrickColor = BrickColor.Black()
	block.Material = Enum.Material.SmoothPlastic
	--block.Material = Enum.Material.Neon
	block.Size = Vector3.one
	block.Position = Vector3.new(output[1]*desired.X,output[2]*desired.Y,output[3]*desired.Z)
	local success = Vector3.new(output[1]*desired.X,output[2]*desired.Y,output[3]*desired.Z) == desired
	local errx,erry,errz = math.abs((desired.X-(output[1]*desired.X))/desired.X),math.abs((desired.Y-(output[2]*desired.Y))/desired.Y),math.abs((desired.Z-(output[3]*desired.Z))/desired.Z)
	--block.Size = Vector3.one*math.abs(err)
	--block.Transparency = math.abs(((errx+erry+errz)/3))
	block.Color = Color3.new(0, 1, 0):Lerp(Color3.new(0.666667, 0, 0),math.abs(((errx+erry+errz)/3)))
	debris:AddItem(block,5)
	--local errorblock = Instance.new("SpawnLocation",worldmodel)
	--errorblock.Enabled = false
	--errorblock.Material = Enum.Material.SmoothPlastic
	--errorblock.Size = Vector3.one
	--errorblock.Color = Color3.new(0, 0, 0)
	--errorblock.CFrame =  CFrame.new(Vector3.zero)* CFrame.new(epoch*errorblock.Size.X,(100*math.abs(1-((errx+erry+errz)/3)))+2.5,0)

	text.TextColor3 =  Color3.new(0, 1, 0):Lerp(Color3.new(0.666667, 0, 0),math.abs(((errx+erry+errz)/3)))
	--text.TextColor3 = Color3.new(0.333333, 1, 0):Lerp(Color3.new(0.666667, 0, 0),math.abs(err))
	text.Text =  
		--string.format("Try %d made it? %s \nDistance: %.3f",epoch,tostring(success),(desired-Vector3.new(output[1]*desired.X,output[2]*desired.Y,output[3]*desired.Z)).Magnitude)
		--string.format("%d Minutes\nNeural Network:\nEpoch %d: \n%.2f Accurate",math.abs(oldtime.Minute-DateTime.now():ToLocalTime().Minute),epoch,100*math.abs(1-(errx+erry+errz)/3))
		string.format("Neural Network:\nEpoch %d: \n%.2f Accurate",epoch,100*math.abs(1-(errx+erry+errz)/3))
	--string.format("Neural Network:\nEpoch %d: \n%.2f%% X Accurate\n%.2f%% Y Accurate\n%.2f%% Z Accurate",epoch,100*math.abs(1-errx),100*math.abs(1-erry),100*math.abs(1-errz))


	--print(desired-Vector3.new(output[1],output[2],output[3]))
	--if  (desired-Vector3.new(output[1]*desired.X,output[2]*desired.Y,output[3]*desired.Z)).Magnitude <= .00001 then
	--if  DateTime.now():ToLocalTime().Minute-oldtime.Minute>= 2 then

	if 100*(math.abs(1-(errx+erry+errz)/3)) > 99.80 then
		--print(string.format("%.1f minutes,%.2f seconds",math.abs(((DateTime.now():ToLocalTime().Millisecond-oldtime.Millisecond)*0.1)*0.166666667),math.abs((DateTime.now():ToLocalTime().Millisecond-oldtime.Millisecond)*0.1)))
		--block.BrickColor = BrickColor.Green()
		--text.TextColor = BrickColor.Green()
		print(string.format("Epoch %d did it. %.2f%% Accurate\n It took %d minutes and %d seconds.\n%.4f Studs Away",epoch,100*(math.abs(1-(errx+erry+errz)/3)),math.abs(DateTime.now():ToLocalTime().Minute-oldtime.Minute),math.abs(DateTime.now():ToLocalTime().Second-oldtime.Second),(desired-Vector3.new(output[1]*desired.X,output[2]*desired.Y,output[3]*desired.Z)).Magnitude))
		local block = Instance.new("SpawnLocation",worldmodel)
		block.Enabled = false
		block.Anchored = true
		block.BrickColor = BrickColor.Green()
		block.Material = Enum.Material.Neon
		block.Size = Vector3.one*.05
		block.Position = desired
		local block2 = Instance.new("SpawnLocation",worldmodel)
		block2.Enabled = false
		block2.Anchored = true
		block2.BrickColor = BrickColor.Red()
		block2.Material = Enum.Material.Neon
		block2.Size = Vector3.one*.05
		block2.Position = Vector3.new(output[1]*desired.X,output[2]*desired.Y,output[3]*desired.Z)
		text.Text = " Training Done"
		break
		--else
		--	--local block = Instance.new("SpawnLocation",worldmodel)
		--	--block.Enabled = false
		--	--block.Anchored = true
		--	--block.BrickColor = BrickColor.Green()
		--	--block.Material = Enum.Material.Neon
		--	--block.Size = Vector3.one*.05
		--	--block.Position = desired
		--	--local block2 = Instance.new("SpawnLocation",worldmodel)
		--	--block2.Enabled = false
		--	--block2.Anchored = true
		--	--block2.BrickColor = BrickColor.Red()
		--	--block2.Material = Enum.Material.Neon
		--	--block2.Size = Vector3.one*.05
		--	--block2.Position = Vector3.new(output[1]*desired.X,output[2]*desired.Y,output[3]*desired.Z)
		--	fails += 1
		--	oldtime =  DateTime.now():ToLocalTime()
		--	training()
	end

	--block.BrickColor = BrickColor.Red()
	--text.TextColor = BrickColor.Red()
	--block.Transparency = .99
end
print("Done")
--ignore the end below.
