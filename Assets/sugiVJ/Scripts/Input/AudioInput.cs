using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class AudioInput : MonoBehaviour
{
	static AudioInput instance;

	public static float AudioLevel {
		get {
			return instance.audioLevel;
		}
	}
	public static float SmoothAudioLevel {
		get {
			return instance.smoothAudioLevel;
		}
	}
	public static float DeltaLevel {
		get {
			return instance.deltaLevel;
		}
	}
	public static float[] AudioSpectrum {
		get {
			return instance.audioSpectrum;
		}
	}

	public float
		audioLevel,
		smoothAudioLevel = 0,
		smoothFactor = 0.1f,
		deltaLevel = 0,
		audioTime = 0;
	public float[] audioSpectrum;
	public float[] rowSpectrum;

	public Texture2D spectrumTex;
	Color[] colors;

	// Use this for initialization
	void Start ()
	{
		instance = this;
		spectrumTex = new Texture2D (512, 1);
	}
	
	// Update is called once per frame
	void Update ()
	{
		var aIn = AudioJack.instance;
		audioLevel = 1.0f + aIn.ChannelRmsLevels.Average () / 40f;
		audioSpectrum = aIn.OctaveBandSpectrum.Select (b => 1.0f + b / 40f).ToArray ();

		smoothAudioLevel = Mathf.Lerp (smoothAudioLevel, audioLevel, smoothFactor);
		deltaLevel = audioLevel - smoothAudioLevel;
		audioTime += Mathf.Max (0, deltaLevel / 20f * Time.deltaTime);

		Shader.SetGlobalFloat ("_AudioLevel", audioLevel);
		Shader.SetGlobalFloat ("_SmoothAudioLevel", smoothAudioLevel);
		Shader.SetGlobalFloat ("_DeltaLevel", deltaLevel);
		Shader.SetGlobalFloat ("_AudioTime", audioTime);

		Shader.SetGlobalInt ("_NumSpectrum", audioSpectrum.Length);
		for (var i = 0; i < audioSpectrum.Length; i++)
			Shader.SetGlobalFloat (string.Format ("_Spectrum{0}", i.ToString ("00")), audioSpectrum [i]);
		foreach (var num in MidiJack.GetKnobNumbers())
			Shader.SetGlobalFloat (string.Format ("_Knob{0}", num.ToString ("00")), MidiJack.GetKnob (num));

		rowSpectrum = aIn.RawSpectrum.Take (512).Select (b => 1.0f + b / 40f).ToArray ();

		spectrumTex.SetPixels (rowSpectrum.Select (
			b => new Color (
				Mathf.Abs (b), 
				Mathf.Abs (b) * 256f - Mathf.Floor (Mathf.Abs (b) * 256f), 
				Mathf.Sign (b))
		).ToArray ());
		spectrumTex.Apply ();
		Shader.SetGlobalTexture ("_SpectrumTex", spectrumTex);
	}
}
