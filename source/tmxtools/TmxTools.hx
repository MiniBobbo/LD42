package tmxtools;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tile.FlxTilemap;
import haxe.crypto.Base64;
import haxe.ds.StringMap;
import haxe.io.Path;
import haxe.xml.Fast;
import logs.Logger;
import openfl.Assets;

/**
 * Parses a tmx object and can create HaxeFlixel objects automatically.
 * @author ...
 */
class TmxTools
{
	var _tmx:String;
	var _imageLocation:String;
	var _dataLocation:String;
	var _maps:StringMap<FlxTilemap>;
	var _tilesets:Array<TmxTileset>;
	public var customProperties(default, null):StringMap<String>;
	var _rects:Array<TmxRect>;
	var _lines:Array<TmxLine>;

	/**
	 * Creates a TmxTools object which can be used to generate FlxTilemaps and get information from TMX files.
	 * Currently has the following restrictions:
	 * Only one tilemap per layer.
	 * Reads in only CSV encoded tile layer data.
	 *
	 * @param	tmxLocation		The name of the tmx file
	 * @param	imageLocation	The location all the image files for the tileset and image objects
	 * @param 	dataLocation	The location of the tmx file and all associated tsx files.  Defaults to the same location as the images.
	 */
	public function new(tmxLocation:String, imageLocation:String = 'assets/images/', ?dataLocation:String)
	{
		if (dataLocation == null)
			dataLocation = imageLocation;
		//Try to get the tmx file.
		_imageLocation = imageLocation;
		_dataLocation = dataLocation;

		_maps = new StringMap<FlxTilemap>();
		_rects = [];
		_tilesets = [];
		_lines = [];
		
		customProperties = new StringMap<String>();

		try
		{
			_tmx = Assets.getText(tmxLocation);
			if (_tmx == null)
			{
				Logger.addLog('Unable to locate tmx file ', tmxLocation,1);
				return;
			}
		}
		catch (err:String)
		{
			Logger.addLog('Unable to load tmx file ', tmxLocation,1);
		}

		//Transform the tmx file into a Fast XML object.
		var x = new Fast(Xml.parse(_tmx).firstElement());

		if(x.hasNode.properties)
			extractCustomProperties(x.node.properties, customProperties);
		
		//Create the tilesets.
		createTilesets(x);

		//Create tiled maps from all the layers with tiles.
		createTileLayers(x);

		//Creates objects from the object layers.
		createObjects(x);

	}

	/**
	 * Populates the object arrays with the contents of the object layer.
	 * @param	x	The tmx file parsed into a Fast XML object.
	 */
	private function createObjects(x:Fast)
	{
		//Loop through all the object layers.
		for (objectLayer in x.nodes.objectgroup)
		{
			//Loop through all of the objects in that object layer.
			for (object in objectLayer.nodes.object)
			{
				//temp variable to hold the type so it can be processed correctly.
				var _type = '';
				if (object.has.width && object.hasNode.text)
					_type = 'text';
				else if (object.has.width && object.hasNode.ellipse)
					_type = 'ellipse';
				else if (object.hasNode.polyline)
					_type = 'line';

				else if (object.has.width)
					_type = 'rect';
				else
					_type = 'poly';

				switch (_type)
				{
					case 'rect':
						var _name = '';
						if (object.has.name)
							_name = object.att.name;
						//Parse out the rectangle.
						var _rect = new FlxRect(Std.parseInt(object.att.x), Std.parseInt(object.att.y), Std.parseInt(object.att.width), Std.parseInt(object.att.height));
						var _properties = new StringMap<String>();
						if(object.has.type)
						_properties.set('type', object.att.type);
						//If we have custom properties, get them and add them to the map.
						if (object.hasNode.properties)
							extractCustomProperties(object.node.properties, _properties);

						var _r:TmxRect =
						{
							name:_name,
							r:_rect,
							properties:_properties
						};

						_rects.push(_r);
					case 'line':
						//Get the first point, because all future points will build off this one.
						var _name = '';
						if (object.has.name) 
							_name = object.att.name;
						var currentPoint = new FlxPoint(Std.parseFloat(object.att.x), Std.parseFloat(object.att.y));
						FlxG.log.add(currentPoint);
						//Make the array of all the points and push the first one on there.
						var points = new Array<FlxPoint>();

						//Parse out the string that has all the next points.  Values are delta from the previous point space delimited.  The X,Y values are comma delimited.
						var p = object.node.polyline.att.points;
						//Break into x,y pairs by space.
						var ps = p.split(' ');

						for (point in ps)
						{
							var nextPoint = new FlxPoint();
							points.push(currentPoint.copyTo(nextPoint).add(Std.parseFloat(point.split(',')[0]),Std.parseFloat(point.split(',')[1])));
						}
						
						var _properties = new StringMap<String>();
						if(object.has.type)
						_properties.set('type', object.att.type);
						//If we have custom properties, get them and add them to the map.
						if (object.hasNode.properties)
							extractCustomProperties(object.node.properties, _properties);
						
							_lines.push({name:_name, points:points, properties:_properties});
						
						
					default:
						Logger.addLog('Object load',_type + ' objects not supported yet',2);
				}

			}
		}
	}

	/**
	 * Parses the properties tag and adds the values to the supplied map
	 * @param	properties	Properties Fast XML object
	 * @param	map			The map that the properties should be added to
	 */
	private function extractCustomProperties(properties:Fast, map:StringMap<String>)
	{
		for (p in properties.nodes.property)
		{
			map.set(p.att.name, p.att.value);
		}
	}

	/**
	 * Creates tilesets from the tileset sections of the tmx file.
	 */
	private function createTilesets(x:Fast):Void
	{
		//Create the tileset objects.
		for (t in x.nodes.tileset)
		{
			//There are two possibilities.  If the tileset is embedded, all the settings are in the pmx file.
			//If not, go to the tsx file to get them.  Check the tileset name attribute to see which case we have.
			if (!t.has.name)
			{
				var tempTS = createTilesetFromTsx(t);
				_tilesets.push(tempTS);
			}
			else
			{
				var tempTS:TmxTileset =
				{
					name:Path.withoutDirectory(t.node.image.att.source),
					firstgid:Std.parseInt(t.att.firstgid),
					tileWidth:Std.parseInt(t.att.tilewidth),
					tileHeight:Std.parseInt(t.att.tileheight),
					tileCount:Std.parseInt(t.att.tilecount),
					height:Std.parseInt(t.node.image.att.height),
					width:Std.parseInt(t.node.image.att.width)
				}

				_tilesets.push(tempTS);
			}
		}
	}

	/**
	 * Reads in an external tsx file and create a tileset from the ressults.
	 * @param	t	The tileset section of the tmx file.
	 */
	private function createTilesetFromTsx(tileset:Fast):TmxTileset
	{
		//Get the tsx name and location.
		var path = _dataLocation + Path.withoutDirectory(tileset.att.source);
		var tsx = new Fast(Xml.parse(Assets.getText(path)).firstElement());

		var ts:TmxTileset = {
			name:Path.withoutDirectory(tsx.node.image.att.source),
			firstgid:Std.parseInt(tileset.att.firstgid),
			tileWidth:Std.parseInt(tsx.att.tilewidth),
			tileHeight:Std.parseInt(tsx.att.tileheight),
			tileCount:Std.parseInt(tsx.att.tilecount),
			height:Std.parseInt(tsx.node.image.att.height),
			width:Std.parseInt(tsx.node.image.att.width),

		};

		return ts;
	}

	/**
	 * Creates a FlxTilemap from each of the tile layers and stores them in the _maps Stringmap by name
	 * @param	tmx		The tmx file to parse.
	 */
	private function createTileLayers(tmx:Fast)
	{
		//Loop through all the layers.
		for (layer in tmx.nodes.layer)
		{
			var tilemap = new FlxTilemap();
			var layername = layer.att.name;
			//If the properties node exists, loop through it and store all the custom properties in a layername:propertyname, value format.
			if (layer.hasNode.properties)
			{
				for (property in layer.node.properties.nodes.property)
				{
					try
					{
						customProperties.set(layername + ":" + property.att.name, property.att.value);
						//Logger.addLog('Added Custom Property', layername + ":" + property.att.name + ', ' + property.att.value);

					}
					catch (err:Dynamic)
					{
						Logger.addLog('custom properties error', err,1);
					}
				}
			}
			//Get the data node.
			var data:Fast = layer.node.data;

			switch (data.att.encoding)
			{
				case 'csv':
					var csv:String = data.innerData;
					var parsedCSV = csv.split(',');
					//The TiledMap.loadMap function needs an array of ints, not strings like we currently have.  We need to build an array of ints.
					var intArray:Array<Int> = [];
					for (i in parsedCSV)
						intArray.push(Std.parseInt(i));
					//Create the tilemap from the intArray.
					CreateTilemapFromIntArray(intArray, layer, layername);

				//case 'base64':
				//var base64 = data.innerData;
				////Convert the base64 string into an array of ints.
				//var result = Base64.decode(base64);
				////Logger.addLog('Base64 Conversion', result.toString());
				default:
					Logger.addLog('Create Tilemap', 'TmxTools does not work with ' + data.att.encoding + ' currently', 1);
			}

		}

	}

	/**
	 * Figures out which tileset is being displayed when supplied with the highest and lowest tile.
	 * @param	highTileID	Highest tileID
	 * @param	lowTileID	Lowest tileID
	 * @return	The tileset.  If multiple, returns null.
	 */
	private function getTilesetFromHighLow(highTileID:Int, lowTileID:Int):TmxTileset
	{
		//Loop through the tilesets and see if the high/low values fall inside this tileset's values.
		var returnTmx:TmxTileset = null;
		for (ts in _tilesets)
		{
			var tsHigh:Int = ts.firstgid + ts.tileCount;
			var tsLow:Int = ts.firstgid;
			//Logger.addLog('checking ' + lowTileID + ', ' + highTileID, 'against ' + ts.name + ': '  + tsLow + ', ' + tsHigh);
			if (highTileID <= tsHigh && highTileID >=lowTileID && lowTileID >= tsLow && lowTileID <= tsHigh )
			{
				returnTmx = ts;
				break;
			}
		}
		return returnTmx;
	}

	function CreateTilemapFromIntArray(intArray:Array<Int>, layer:Fast, layername:String):Void
	{
		var high:Int = 0;
		var low:Int = 9999;
		//Loop through the array and find the high and low values.
		for (i in 0...intArray.length)
		{
			var ii = intArray[i];
			//building the array of ints for the loadMap function.
			if (ii != 0)
			{
				if ( ii > high)
					high = ii;
				if ( ii < low)
					low = ii;
			}
		}
		var tileSet = getTilesetFromHighLow(high, low);
		if (tileSet == null)  {
			Logger.addLog('Tileset not found', "Couldn't find tileset for " + layer.att.name, 1);
			return;
		}

		//We need to subtract the startgid from the tile array so the indexes line up with the tileset since we don't allow multiple.
		for (i in 0...intArray.length)
		{
			if (intArray[i] != 0 )
			{
				intArray[i] -= tileSet.firstgid;
			}
		}

		var _tilemap:FlxTilemap = new FlxTilemap();
		//Create the tilemap and load it into the _maps variable.
		_tilemap.loadMapFromArray(intArray, Std.parseInt(layer.att.width), Std.parseInt(layer.att.height), _imageLocation + tileSet.name, tileSet.tileWidth, tileSet.tileHeight,null,0,1,0);
		_maps.set(layername, _tilemap);

	}

	/**
	 * Gets a map from the TmxTools cache by name.  A different tilemap is created for each layer, so the name is equal to the name of the layer in the tmx.
	 * @param	mapName		Name of the map to retreive.
	 * @return	The map
	 */
	public function getMap(mapName:String):FlxTilemap
	{
		if (!_maps.exists(mapName))
		{
			Logger.addLog("Can't find map in the map cache:", mapName, 1);
		}

		return _maps.get(mapName);
	}

	public function getTmxRectanges():Array<TmxRect>
	{
		return _rects;
	}
	
	public function getTmxLines():Array<TmxLine>
	{
		return _lines;
	}
	
	public function listMaps() {
		trace('maps: ');
		for (m in _maps.keys()) {
			trace(m);
		}
	}
}