using UnityEngine;
using System.Collections;

public class SetMaterialProp : MonoBehaviour {
	
	public string propName;
	public propType type;
	
	public float f;
	public Vector4 v;
	public Color c;
	public Texture t;
	
	Material m;
	// Use this for initialization
	void Start () {
		m = renderer.material;
		switch(type){
		case propType.Color:
			m.SetColor(propName, c);
			break;
		case propType.Float:
			m.SetFloat(propName, f);
			break;
		case propType.Texture:
			m.SetTexture(propName, t);
			break;
		case propType.Vector:
			m.SetVector(propName, v);
			break;
		}
	}
	
	// Update is called once per frame
	void OnDestroy () {
		if(m != null)
			Destroy(m);
	}
	
	public enum propType{
		Float = 0,
		Vector = 1,
		Color = 2,
		Texture = 3,
	}
}
