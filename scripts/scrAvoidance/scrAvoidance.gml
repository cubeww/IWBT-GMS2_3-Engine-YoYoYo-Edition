/// @function scrMakeCircle(x,y,layer,angle,numProjectiles,speed,obj)
/// @description Spawns a ring of projectiles
/// @param x spawn X
/// @param y spawn Y
/// @param layer spawn layer
/// @param angle starting angle
/// @param numProjectiles number of projectiles to spawn
/// @param speed speed
/// @param obj projectile object to spawn
function scrMakeCircle(spawnX, spawnY, spawnLayer, spawnAngle, spawnNum, spawnSpeed, spawnObj) {
	var a;

	for (var i = 0; i < spawnNum; i += 1) {
		a = instance_create_layer(spawnX, spawnY, spawnLayer, spawnObj);
		a.speed = spawnSpeed;
		a.direction = spawnAngle + i * (360 / spawnNum);
	}
}

/// @function scrMakeShapes(x,y,layer,angle,edges,numProjectiles,speed,obj)
/// @description Spawns a custom shape
/// @param x spawn X
/// @param y spawn Y
/// @param layer spawn layer
/// @param angle starting angle
/// @param edges number of edges (3=triangle, 4=square, etc.)
/// @param numProjectiles projectile spawns per edge
/// @param speed speed
/// @param obj projectile object to spawn
function scrMakeShapes(spawnX, spawnY, spawnLayer, spawnAngle, spawnEdges, spawnNum, spawnSpeed, spawnObj) {
	var th, xx, yy, ddx, ddy, dx, dy, a;

	th = degtorad(spawnAngle);

	for (var i = 0; i < spawnEdges; i += 1) {
		xx[i] = cos(th + 2 * pi * i / spawnEdges);
		yy[i] = sin(th + 2 * pi * i / spawnEdges);
	}

	xx[spawnEdges] = xx[0];
	yy[spawnEdges] = yy[0];

	for (var i = 0; i < spawnEdges; i += 1) {
		ddx = xx[i + 1] - xx[i];
		ddy = yy[i + 1] - yy[i];

		for (var j = 0; j < spawnNum; j += 1) {
			dx = xx[i] + ddx * j / spawnNum;
			dy = yy[i] + ddy * j / spawnNum;

			a = instance_create_layer(spawnX + dx, spawnY + dy, spawnLayer, spawnObj);
			a.direction = point_direction(0, 0, dx, dy);
			a.speed = spawnSpeed * point_distance(0, 0, dx, dy);
		}
	}
}