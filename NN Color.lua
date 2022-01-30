oldtime = os.time()
--time coversions
function tomins(timeamount)
	return (timeamount)/60
end
function tohours(timeamount)
	return tomins(timeamount)/60
end
function todays(timeamount)
	return tohours(timeamount)/24
end
function toweeks(timeamount)
	return todays(timeamount)/7
end
function tomonths(timeamount)
	return toweeks(timeamount)/4.3452380952
end
function toyears(timeamount)
	return tomonths(timeamount)/12.008219178
end


	local debris = game:GetService("Debris")
	local max = 1016.8157
	local worldmodel = Instance.new("WorldModel",script)

local block = Instance.new("SpawnLocation",worldmodel)
block.Enabled = false
block.BrickColor = BrickColor.Black()
block.Material = Enum.Material.SmoothPlastic
task.spawn(function()
	while task.wait() do
		block.CFrame =  owner.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-5)
	end
end)
task.spawn(function()
	while task.wait() do
		local raycast = workspace:Raycast(block.Position,block.CFrame.LookVector*1000)
		if raycast and raycast.Instance then
			color =  raycast.Instance.Color
		else
			color = Color3.new(1, 1, 1)
		end
	end
end)
for i = 1,math.huge do
task.wait()
		--block.Position = Vector3.one*math.random(-100,100)
		--block.Size = Vector3.one*math.random(0,100)
		local desired = color
		local output = propogateForward({block.Color.R,block.Color.G,block.Color.B})
		propogateBackwards({(desired.R),desired.G,desired.B})
		updateNetwork()
		block.Color = Color3.new(output[1],output[2],output[3])
		block.Size = Vector3.one
	if block.Color ==  desired then
			block.Transparency = 0
		if math.round(os.time()-oldtime) <= 60 then
			if  math.round(os.time()-oldtime) ~= 1 then
				print("Try # "..i.. " did it. It took "..(tomins(os.time()-oldtime)).. " seconds.")
				debris:AddItem(block,.1) break
			elseif math.round(os.time()-oldtime) == 1 then
				print("Try # "..i.. " did it. It took "..(tomins(os.time()-oldtime)).. "second.")
				debris:AddItem(block,.1) break
			elseif math.round(tomins(os.time()-oldtime)) ~= 1 then
				print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. " minutes.")
				debris:AddItem(block,.1) break
			elseif math.round(tomins(os.time()-oldtime)) == 1 then
				print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. " minute.")
				debris:AddItem(block,.1) break
			elseif math.round(tomins(os.time()-oldtime)) <= 60 then
				if math.round(tohours(os.time()-oldtime)) ~= 1 then
					print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. " hours.")
					debris:AddItem(block,.1) break
				elseif math.round(tohours(os.time()-oldtime)) == 1 then
					print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. " hour.")
					debris:AddItem(block,.1) break
				end
			elseif math.round(tohours(os.time()-oldtime)) <= 24 then
				if math.round(todays(os.time()-oldtime)) ~= 1 then
					print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. "days.")
					debris:AddItem(block,.1) break
				elseif math.round(todays(os.time()-oldtime)) == 1 then
					print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. "day.")
					debris:AddItem(block,.1) break
				end
			elseif math.round(todays(os.time()-oldtime)) <= 7 then
				if math.round(toweeks(os.time()-oldtime)) ~= 1 then
					print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. "weeks.")
					debris:AddItem(block,.1) break
				elseif math.round(toweeks	(os.time()-oldtime)) == 1 then
					print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. "week.")
					debris:AddItem(block,.1) break
				end
			elseif math.round(toweeks(os.time()-oldtime)) <= 4 then
				if math.round(tomonths(os.time()-oldtime)) ~= 1 then
					print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. "months.")
					debris:AddItem(block,.1) break
				elseif math.round(tomonths(os.time()-oldtime)) == 1 then
					print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. "month.")
					debris:AddItem(block,.1) break
				end
			elseif math.round(tomonths(os.time()-oldtime)) <= 12 then
				if math.round(toyears(os.time()-oldtime)) ~= 1 then
					print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. "years.")
					debris:AddItem(block,.1) break
				elseif math.round(toyears(os.time()-oldtime)) == 1 then
					print("Try # "..i.. " did it. It took "..math.round(tomins(os.time()-oldtime)).. "year.")
					debris:AddItem(block,.1) break
				end
			end
		end
end
	end
