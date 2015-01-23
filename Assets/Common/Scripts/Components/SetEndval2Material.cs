using UnityEngine;
using System.Collections;

public class SetEndval2Material : MonoBehaviour {
	
	public float
		endTime = 60f,
		endSpeed = 3f;
	public string
		propName = "_End";
	public Shader endShader;
	
	public bool sendMessage;
	public string message = "OnEndMaterial";
	
	float firstTime,e;
	Renderer r;
	Material[] ms;
	bool changed;
	
	public SetEndval2Material End(float t = 0){
		if(Time.timeSinceLevelLoad - firstTime - endTime < 0)
			endTime = Time.timeSinceLevelLoad - firstTime + t;
		return this;
	}
	
	public float time2End{
		get{ return endTime - (Time.timeSinceLevelLoad - firstTime);}
	}
	
	// Use this for initialization
	void Awake () {
		r = GetComponentInChildren<Renderer>();
		if(r == null)
			Destroy(this);
		ms = r.materials;
		foreach(Material m in ms)
			m.SetFloat(propName, 0);
		firstTime = Time.timeSinceLevelLoad;
	}
	
	// Update is called once per frame
	void Update () {
		e = Time.timeSinceLevelLoad - firstTime - endTime;
		if(e < 0)
			return;

		e *= endSpeed;
		SendMessage("FadeOut", SendMessageOptions.DontRequireReceiver);

		if(endShader!=null){
			foreach(Material m in ms)
				m.shader = endShader;
			endShader = null;
		}
		foreach(Material m in ms)
			m.SetFloat(propName, e);
		
		if(sendMessage)
			BroadcastMessage(message, SendMessageOptions.DontRequireReceiver);
		sendMessage = false;
	}
	
	void OnDestroy(){
		if(ms != null)
			foreach(Material m in ms)
				if(m != null)
					Destroy(m);
	}
}
