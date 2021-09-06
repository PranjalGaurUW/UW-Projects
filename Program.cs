using System;
using System.Collections.Generic;
namespace median_sorted_array
{
    class Program
    {
        static void Main(string[] args)
        {
            //Console.WriteLine("Hello World!");
            int[] arr1 = { 0,0 };
            int[] arr2 = { 0,0 };
            Program obj = new Program();
            var result=obj.FindMedianSortedArrays(arr1, arr2);
            Console.WriteLine("------->"+ result);
        }
	//created develop branch for dev purposes
        public double FindMedianSortedArrays(int[] nums1, int[] nums2)
        {
            double median = 0.0; List<int>sorted_merged_array = new List<int>();

            int i = 0, j = 0; int size = nums1.Length+ nums2.Length;
            while(i<nums1.Length && j<nums2.Length)
            {
                if (nums1[i] <= nums2[j])
                {
                    sorted_merged_array.Add(nums1[i]);
                    i++;
                    //dhdj
                }

                else if(nums2[j]<nums1[i])
                {
                    sorted_merged_array.Add(nums2[j]);
                    j++;
                }
                                
            }
            //test comment
            //latest comment
            if (i < nums1.Length)
            {
                while (i < nums1.Length)
                    sorted_merged_array.Add(nums1[i++]);
            }

            if (j < nums2.Length)
            {
                while (j < nums2.Length)
                    sorted_merged_array.Add(nums2[j++]);
            }

            if (size % 2 == 0)
            {
                int a = sorted_merged_array[size / 2 - 1];
                int b = sorted_merged_array[size / 2];
                median = (double)(a+b) / 2;
            }
            else
            {
                median = sorted_merged_array[(size + 1) / 2 - 1];
            }
            return median;
        }
    }
}
