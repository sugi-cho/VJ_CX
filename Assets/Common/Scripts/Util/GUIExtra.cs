using UnityEngine;
using System.Collections;

public class GUIExtra
{
	public static float FloatField (string label, float val)
	{
		GUILayout.BeginHorizontal ();
		GUILayout.Label (label);
		string s = GUILayout.TextField (val.ToString ());
		float f;
		if (float.TryParse (s, out f))
			val = f;
		GUILayout.EndHorizontal ();
		return val;
	}
	public static float FloatField (string label, float val, float leftVal, float rightVal)
	{
		val = FloatField (label, val);
		val = GUILayout.HorizontalSlider (val, leftVal, rightVal);
		return val;
	}
}
