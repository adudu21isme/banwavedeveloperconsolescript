--// adudu21's Ban-Wave Developer-Console Script

print("⏳ Preparing...")
--// Services
local plrs = game:GetService("Players")--// Used for BanAsync

--// Vars
local list = [[REPLACE WITH DATA]]--// Example:roblox.com/users/1,roblox.com/users/12,roblox.com/users/123
local uids = {}--// Banlist (data extracted from list)
local s = os.clock()--// Elapsed time

--// Convert list into userids
for u in string.gmatch(list,"roblox.com/users/(%d+)") do table.insert(uids,tonumber(u))end

--// Total userids
local tuids = #uids

--// Roblox's BanAsync limit is 50
print("⏳ Started!")
for n=1,tuids,50 do
   --// Batch of 50
   local batch = {}
   for d=n,math.min(n+50-1,tuids) do table.insert(batch,uids[d])end
   --// Handle errors
   local s,r,t = nil,nil,3
   repeat
      s,r = pcall(function()
         return plrs:BanAsync({UserIds=batch,Duration=-1,DisplayReason="Ban reason here.",PrivateReason="Ban reason here (unfiltered) - Moderators here or remove",ExcludeAltAccounts=false,ApplyToUniverse=true})  
      end)
      if not s then
         if string.find(r,"NOT_FOUND") then --// Avoid errors from terminated users
            s="t"
         else t-=1 task.wait(0.5)
         end
      end
   until s or t==0
   if s then
      if s=="t" then print(`🔨⚠️User is terminated. Banned: {table.concat(batch, ", ")}`) else print(`🔨Banned: {table.concat(batch, ", ")}`) end
   else warn(`❌Failure: {r}`)
   end
end
print(`✅Finished! Took {os.clock()-s} seconds!`)
