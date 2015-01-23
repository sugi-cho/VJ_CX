using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[System.Serializable]
public class Bisection
{
	public float weight;
	float value;

	public Bisection (float w)
	{
		weight = w;
	}

	public static void SetBisectionVal (Bisection[] bs)
	{
		float sum = 0;
		foreach (var b in bs) {
			sum += b.weight;
		}

		float sum1 = 0;
		for (int i = 0; i < bs.Length; i++) 
			bs [i].value = (sum1 += bs [i].weight) / sum;
	}

	public static int GetIndex (Bisection[] bs, float target)
	{
		int
		s1 = 0,
		s2 = bs.Length;

		for (int i = 0; i < 50; i++) {
			int center = (s1 + s2) / 2;
			if (bs [center].value < target)
				s1 = center;
			else
				s2 = center;
			if (s1 + 1 == s2)
				return s1;
		}
		return s1;
	}
}
