class GuideComb < CrystalScad::Printed

	def initialize()
		@length = 30
		@width = 101
		@height = 10

		@fin_height = 50
		@fin_position = 22

		@shuttle_position_x = @fin_position + 5
		@shuttle_position_z = 16
	
		@side_wall_length = 20

		@total_width = @width+@side_wall_length*2
		
		@hardware = []
		@side_mount_nuts = []
		@transformations = []
		@color = "OldLace"
	end

	def comb_center(multiplier=1)
		{x:@shuttle_position_x*multiplier,z:@shuttle_position_z*multiplier}
	end

	def part(show)
		# sidewall
		res = SideWall.new(length:@length,height:@height,width:@width).part(show)
		res += fins_and_side_walls			
		@hardware << Bolt.new(5,30).rotate(y:-90).translate(x:40,y:-@side_wall_length/2.0+3,z:@fin_height-10)
		@hardware << Bolt.new(5,30).rotate(y:-90).translate(x:40,y:@width+@side_wall_length/2.0-3,z:@fin_height-10)

		@hardware << Nut.new(5,height:7).rotate(y:-90).translate(x:18,y:-@side_wall_length/2.0+3,z:@fin_height-10)
		@hardware << Nut.new(5,height:7).rotate(y:-90).translate(x:18,y:@width+@side_wall_length/2.0-3,z:@fin_height-10)

		# as this cube doesn't connect all the way down, add another cube that does
		res += cube([4,@total_width,4]).translate(x:-4,y:-@side_wall_length)

		# cut a bit of excess material on the top
		res -= cube([4,@total_width,@fin_height]).translate(x:@fin_position,y:-@side_wall_length,z:@height)

		@hardware << Nut.new(4,slot:20,slot_direction:"y",cylinder_length:15).rotate(x:90).mirror(y:1).translate(x:5,y:@width+12,z:10)
		@hardware << Nut.new(4,slot:20,slot_direction:"y",cylinder_length:15).rotate(x:90).mirror(y:1).translate(x:17,y:@width+12,z:38)
	
		@side_mount_nuts << Nut.new(4,slot:20,slot_direction:"y",cylinder_length:15,direction:"-y").rotate(x:90).translate(x:5,y:-12,z:10)
		@side_mount_nuts << Nut.new(4,slot:20,slot_direction:"y",cylinder_length:15,direction:"-y").rotate(x:90).translate(x:17,y:-12,z:38)

	
		@hardware += @side_mount_nuts

		res -= @hardware 
		res = colorize(res)
		

		res
	end

	def fins_and_side_walls
		res = nil
		# fins
		(0..40).each do |i|
			res += fin.translate(y:i*2.5+1)	
		end
	
		# add side walls in the shape of fins
		res += fin(@side_wall_length).translate(y:0)		
		res += fin(@side_wall_length).translate(y:@width+@side_wall_length)		
		# Add a cube to act as "bottom", connecting fins and sidewall
		res += cube([4,@total_width,@fin_height+4]).rotate(y:25).translate(x:-4,y:-@side_wall_length,z:3)

		res
	end

	def fin(height=1)
		res = square([60,3])
		res += polygon(points:[[0,3],[@fin_position,0],[@fin_position,@fin_height]])			
		res -= circle(d:26,fn:8).rotate(z:22.5).translate(x:@shuttle_position_x,y:@shuttle_position_z)
		res.linear_extrude(h:height).rotate(x:90)
	end

end	

